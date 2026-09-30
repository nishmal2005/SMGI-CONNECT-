import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_endpoints.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const Duration _timeout = Duration(seconds: 30);
  static const String _accessKey = 'access_token';
  static const String _refreshKey = 'refresh_token';

  Future<bool>? _refreshing;

  // ── Public API ───────────────────────────────────

  Future<dynamic> get(
    String path, {
    Map<String, String>? query,
    bool authenticated = true,
  }) =>
      _request('GET', path, query: query, authenticated: authenticated);

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) =>
      _request('POST', path, body: body, authenticated: authenticated);

  Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) =>
      _request('PATCH', path, body: body, authenticated: authenticated);

  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) =>
      _request('DELETE', path, body: body, authenticated: authenticated);

  // ── Multipart ────────────────────────────────────

  Future<dynamic> multipart(
    String path, {
    required Map<String, String> fields,
    Map<String, File> files = const {},
    bool authenticated = true,
    String method = 'POST',
  }) async {
    final uri = Uri.parse('${ApiEndpoints.baseUrl}$path');
    final stopwatch = Stopwatch()..start();

    try {
      final request = http.MultipartRequest(method, uri);

      if (authenticated) {
        final token = await accessToken;
        if (token != null && token.isNotEmpty) {
          request.headers['Authorization'] = 'Bearer $token';
        }
      }
      request.headers['Accept'] = 'application/json';

      request.fields.addAll(fields);

      for (final entry in files.entries) {
        final file = entry.value;
        final exists = await file.exists();
        if (!exists) {
          throw ApiException('File "${entry.value.path}" no longer exists.');
        }
        final size = await file.length();
        if (size == 0) {
          throw ApiException('File for "${entry.key}" is empty.');
        }
        request.files.add(
          await http.MultipartFile.fromPath(entry.key, file.path),
        );
      }

      if (kDebugMode) {
        debugPrint(
          '$_cyan→ $method $_reset$uri '
          '$_dim(multipart, auth=${request.headers.containsKey('Authorization')})$_reset',
        );
        if (fields.isNotEmpty) {
          debugPrint('$_dim  fields: ${fields.keys.join(', ')}$_reset');
        }
        for (final entry in files.entries) {
          final size = await entry.value.length();
          final name = entry.value.path.split(Platform.pathSeparator).last;
          debugPrint(
            '$_dim  file[${entry.key}]: $name ($size bytes)$_reset',
          );
        }
      }

      final streamed = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamed);
      stopwatch.stop();
      _logResponse(method, uri, response, stopwatch.elapsedMilliseconds);
      return _decode(response);
    } on ApiException {
      stopwatch.stop();
      rethrow;
    } on Exception catch (e) {
      stopwatch.stop();
      final msg = 'Multipart request failed: $e';
      _logError(method, uri, msg, stopwatch.elapsedMilliseconds);
      throw ApiException(msg);
    }
  }

  // ── Token storage ────────────────────────────────

  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessKey, access);
    await prefs.setString(_refreshKey, refresh);
    if (kDebugMode) {
      debugPrint(
        '$_green✓ tokens saved: access len=${access.length} '
        'refresh len=${refresh.length}$_reset',
      );
    }
  }

  Future<void> saveAccessToken(String access) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessKey, access);
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
    if (kDebugMode) {
      debugPrint('$_yellow✓ tokens cleared$_reset');
    }
  }

  Future<String?> get accessToken async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessKey);
  }

  Future<String?> get refreshToken async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshKey);
  }

  /// True if an access token is stored.
  Future<bool> get isLoggedIn async {
    final token = await accessToken;
    return token != null && token.isNotEmpty;
  }

  // ── Core ─────────────────────────────────────────

  Future<dynamic> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? query,
    bool authenticated = true,
    bool retryOnUnauthorized = true,
  }) async {
    final uri = Uri.parse('${ApiEndpoints.baseUrl}$path')
        .replace(queryParameters: query);
    final headers = await _headers(authenticated);
    final encoded = body == null ? null : jsonEncode(body);
    final stopwatch = Stopwatch()..start();

    _logRequest(method, uri, headers, encoded);

    try {
      final response =
          await _send(method, uri, headers, encoded).timeout(_timeout);

      if (response.statusCode == 401 &&
          authenticated &&
          retryOnUnauthorized) {
        stopwatch.stop();
        _logResponse(method, uri, response, stopwatch.elapsedMilliseconds);

        final refreshed = await _refreshAccessToken();
        if (!refreshed) {
          await clearTokens();
          throw ApiException(
            'Session expired. Please log in again.',
            statusCode: 401,
          );
        }

        return _request(
          method,
          path,
          body: body,
          query: query,
          authenticated: authenticated,
          retryOnUnauthorized: false,
        );
      }

      stopwatch.stop();
      _logResponse(method, uri, response, stopwatch.elapsedMilliseconds);
      return _decode(response);
    } on ApiException catch (e) {
      _logError(method, uri, e.message, stopwatch.elapsedMilliseconds);
      rethrow;
    } on Exception catch (e) {
      stopwatch.stop();
      final msg = 'Could not reach the server: $e';
      _logError(method, uri, msg, stopwatch.elapsedMilliseconds);
      throw ApiException(msg);
    }
  }

  Future<http.Response> _send(
    String method,
    Uri uri,
    Map<String, String> headers,
    String? body,
  ) {
    switch (method) {
      case 'GET':
        return _client.get(uri, headers: headers);
      case 'POST':
        return _client.post(uri, headers: headers, body: body);
      case 'PATCH':
        return _client.patch(uri, headers: headers, body: body);
      case 'DELETE':
        return _client.delete(uri, headers: headers, body: body);
      default:
        throw ApiException('Unsupported HTTP method: $method');
    }
  }

  Future<Map<String, String>> _headers(bool authenticated) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (authenticated) {
      final token = await accessToken;
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Future<bool> _refreshAccessToken() {
    final existing = _refreshing;
    if (existing != null) return existing;

    final future = _doRefresh();
    _refreshing = future;
    future.whenComplete(() => _refreshing = null);
    return future;
  }

  Future<bool> _doRefresh() async {
    final refresh = await refreshToken;
    if (refresh == null || refresh.isEmpty) return false;

    final uri = Uri.parse(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.tokenRefresh}',
    );

    try {
      if (kDebugMode) {
        debugPrint('$_cyan→ POST $_reset$uri $_dim(refresh token)$_reset');
      }

      final response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refresh': refresh}),
          )
          .timeout(_timeout);

      if (kDebugMode) {
        debugPrint(
          '$_dim← refresh ${response.statusCode} '
          '(${response.body.length}B)$_reset',
        );
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return false;
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map) return false;

      final access = decoded['access']?.toString() ??
          decoded['access_token']?.toString() ??
          decoded['token']?.toString();

      if (access == null || access.isEmpty) return false;

      await saveAccessToken(access);
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('$_red✖ refresh failed: $e$_reset');
      }
      return false;
    }
  }

  dynamic _decode(http.Response response) {
    final contentType = response.headers['content-type'] ?? '';
    final isJson = contentType.contains('application/json');

    dynamic data;
    if (response.body.isEmpty) {
      data = null;
    } else if (isJson) {
      try {
        data = jsonDecode(response.body);
      } on FormatException {
        data = response.body;
      }
    } else {
      data = response.body;
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = contentType.contains('text/html')
          ? 'Endpoint not found or server error (${response.statusCode})'
          : _message(data);
      throw ApiException(message, statusCode: response.statusCode);
    }
    return data;
  }

  String _message(dynamic data) {
    if (data is Map<String, dynamic>) {
      final detail = data['error'] ??
          data['detail'] ??
          data['message'] ??
          data.values.firstWhere((v) => v != null, orElse: () => null);
      if (detail is List && detail.isNotEmpty) {
        return detail.first.toString();
      }
      return detail?.toString() ?? 'Request failed';
    }
    return data?.toString() ?? 'Request failed';
  }

  // ── Logging ──────────────────────────────────────

  static const _reset = '\x1B[0m';
  static const _green = '\x1B[32m';
  static const _yellow = '\x1B[33m';
  static const _red = '\x1B[31m';
  static const _cyan = '\x1B[36m';
  static const _dim = '\x1B[2m';

  void _logRequest(
    String method,
    Uri uri,
    Map<String, String> headers,
    String? body,
  ) {
    if (!kDebugMode) return;
    debugPrint(
      '$_cyan→ $method $_reset$uri '
      '$_dim(auth=${headers.containsKey('Authorization')})$_reset',
    );
    if (body != null && body.isNotEmpty) {
      debugPrint('$_dim  body: ${_truncate(body, 400)}$_reset');
    }
  }

  void _logResponse(
    String method,
    Uri uri,
    http.Response response,
    int ms,
  ) {
    if (!kDebugMode) return;
    final code = response.statusCode;
    final color = code >= 500
        ? _red
        : code >= 400
            ? _yellow
            : _green;
    debugPrint(
      '$color← $code $_reset$method ${uri.path} '
      '$_dim(${ms}ms, ${response.body.length}B)$_reset',
    );
    if (response.body.isNotEmpty && code >= 400) {
      debugPrint('$_dim  body: ${_truncate(response.body, 400)}$_reset');
    }
  }

  void _logError(String method, Uri uri, String message, int ms) {
    if (!kDebugMode) return;
    debugPrint(
      '$_red✖ $method ${uri.path} — $message '
      '$_dim(${ms}ms)$_reset',
    );
  }

  String _truncate(String s, int max) =>
      s.length <= max ? s : '${s.substring(0, max)}…';
}