import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiClient {
  static const String baseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: 'http://192.168.0.223:8001/api',
  );
  static const Duration timeout = Duration(seconds: 30);

  Future<dynamic> request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? query,
    bool authenticated = true,
  }) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    final headers = await _headers(authenticated);
    final encodedBody = body == null ? null : jsonEncode(body);
    try {
      final response = await _send(
        method,
        uri,
        headers,
        encodedBody,
      ).timeout(timeout);
      final data = _decode(response);
      await _storeAuthenticationResult(path, data);
      return data;
    } on ApiException {
      rethrow;
    } on Exception catch (error) {
      throw ApiException('Could not reach the server: $error');
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
        return http.get(uri, headers: headers);
      case 'POST':
        return http.post(uri, headers: headers, body: body);
      case 'PATCH':
        return http.patch(uri, headers: headers, body: body);
      case 'DELETE':
        return http.delete(uri, headers: headers, body: body);
      default:
        throw ApiException('Unsupported HTTP method: $method');
    }
  }

  Future<Map<String, String>> _headers(bool authenticated) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (authenticated) {
      final preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('access_token');
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  dynamic _decode(http.Response response) {
    dynamic data;
    if (response.body.isEmpty) {
      data = null;
    } else {
      try {
        data = jsonDecode(response.body);
      } on FormatException {
        data = response.body;
      }
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        'Request failed (${response.statusCode}): ${_message(data)}',
        statusCode: response.statusCode,
      );
    }
    return data;
  }

  String _message(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['detail']?.toString() ??
          data['message']?.toString() ??
          data.values.join(', ');
    }
    return data?.toString().isNotEmpty == true
        ? data.toString()
        : 'Empty response from server';
  }

  Future<void> _storeAuthenticationResult(String path, dynamic data) async {
    final preferences = await SharedPreferences.getInstance();
    if (path == '/logout/') {
      await preferences.remove('access_token');
      await preferences.remove('refresh_token');
      return;
    }
    if ((path == '/login/' || path == '/admin/auth/login/') && data is Map) {
      final access = data['access']?.toString();
      final refresh = data['refresh']?.toString();
      if (access != null && refresh != null) {
        await preferences.setString('access_token', access);
        await preferences.setString('refresh_token', refresh);
      }
    }
  }
}
