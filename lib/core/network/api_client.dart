import 'dart:convert';

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

  // ── Public API ───────────────────────────────────

  Future<dynamic> get(String path, {Map<String, String>? query, bool authenticated = true}) =>
      _request('GET', path, query: query, authenticated: authenticated);

  Future<dynamic> post(String path, {Map<String, dynamic>? body, bool authenticated = true}) =>
      _request('POST', path, body: body, authenticated: authenticated);

  Future<dynamic> patch(String path, {Map<String, dynamic>? body, bool authenticated = true}) =>
      _request('PATCH', path, body: body, authenticated: authenticated);

  Future<dynamic> delete(String path, {Map<String, dynamic>? body, bool authenticated = true}) =>
      _request('DELETE', path, body: body, authenticated: authenticated);

  // ── Token storage ────────────────────────────────

  Future<void> saveTokens({required String access, required String refresh}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessKey, access);
    await prefs.setString(_refreshKey, refresh);
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
  }

  Future<String?> get accessToken async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessKey);
  }

  // ── Core ─────────────────────────────────────────

  Future<dynamic> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? query,
    bool authenticated = true,
  }) async {
    final uri = Uri.parse('${ApiEndpoints.baseUrl}$path')
        .replace(queryParameters: query);
    final headers = await _headers(authenticated);
    final encoded = body == null ? null : jsonEncode(body);
    final stopwatch = Stopwatch()..start();

    _logRequest(method, uri, headers, encoded);

    try {
      final response = await _send(method, uri, headers, encoded).timeout(_timeout);
      stopwatch.stop();
      _logResponse(method, uri, response, stopwatch.elapsedMilliseconds);
      return _decode(response);
    } on ApiException catch (e) {
      stopwatch.stop();
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
      // For HTML error pages (Django's 404/500), don't dump megabytes into the UI.
      final message = contentType.contains('text/html')
          ? 'Endpoint not found or server error (${response.statusCode})'
          : _message(data);
      throw ApiException(message, statusCode: response.statusCode);
    }
    return data;
  }

  String _message(dynamic data) {
    if (data is Map<String, dynamic>) {
      final detail = data['detail'] ??
          data['message'] ??
          data.values.firstWhere((v) => v != null, orElse: () => null);
      return detail?.toString() ?? 'Request failed';
    }
    return data?.toString() ?? 'Request failed';
  }

  // ─────────────────────────────────────────────────────
  // Logging
  // ─────────────────────────────────────────────────────

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
      '$_cyan→ $method $_reset${uri.toString()} '
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