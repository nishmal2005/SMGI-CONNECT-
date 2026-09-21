import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.0.223:8001/api';
  static const Duration _requestTimeout = Duration(seconds: 15);

  // ================= SEND OTP =================

  Future<void> sendOtp(String input) async {
    final res = await http
        .post(
          Uri.parse('$baseUrl/send-otp/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': input}),
        )
        .timeout(_requestTimeout);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw AuthRequestException(_responseMessage(res.body));
    }
  }

  // ================= PASSWORD RESET OTP =================

  Future<void> requestPasswordReset(String email) async {
    final res = await http
        .post(
          Uri.parse('$baseUrl/password-reset/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email}),
        )
        .timeout(_requestTimeout);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw AuthRequestException(_responseMessage(res.body));
    }
  }

  Future<void> resendOtp(String email) async {
    final res = await http
        .post(
          Uri.parse('$baseUrl/resend-otp/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email}),
        )
        .timeout(_requestTimeout);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw AuthRequestException(_responseMessage(res.body));
    }
  }

  // ================= VERIFY OTP =================

  Future<bool> verifyOtp(String email, String otp) async {
    final res = await http.post(
      Uri.parse('$baseUrl/verify-otp/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );
    return res.statusCode == 200;
  }

  // ================= SET PASSWORD =================

  Future<bool> register({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
      }),
    );
    print('REGISTER STATUS: ${res.statusCode}');
    print('REGISTER BODY: ${res.body}');

    return res.statusCode == 201;
  }

  // ================= LOGIN =================

  Future<bool> login(String email, String password) async {
    late final http.Response res;
    try {
      res = await http
          .post(
            Uri.parse('$baseUrl/login/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(_requestTimeout);
    } on Exception catch (error) {
      throw AuthRequestException('Could not reach the login server: $error');
    }

    print('LOGIN STATUS: ${res.statusCode}');
    print('LOGIN BODY: ${res.body}');

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;

      if (data['access'] == null || data['refresh'] == null) {
        throw const AuthRequestException(
          'Login succeeded, but the server returned no tokens.',
        );
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', data['access']);
      await prefs.setString('refresh_token', data['refresh']);
      return true;
    }

    throw AuthRequestException(
      'Login failed (${res.statusCode}): ${_responseMessage(res.body)}',
    );
  }

  String _responseMessage(String body) {
    try {
      final data = jsonDecode(body);
      if (data is Map<String, dynamic>) {
        return data['detail']?.toString() ??
            data['message']?.toString() ??
            data.values.join(', ');
      }
    } on FormatException {
      // Keep the raw response when the server did not return JSON.
    }
    return body.isEmpty ? 'Empty response from server' : body;
  }

  // ================= LOGOUT =================

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString('access_token');
    final refreshToken = prefs.getString('refresh_token');

    print('ACCESS TOKEN: $accessToken');
    print('REFRESH TOKEN: $refreshToken');

    if (accessToken != null && refreshToken != null) {
      final res = await http.post(
        Uri.parse('$baseUrl/logout/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'refresh': refreshToken}),
      );

      print('LOGOUT STATUS: ${res.statusCode}');
      print('LOGOUT BODY: ${res.body}');
    }
    // ALWAYS clear tokens
    await prefs.clear();
  }

  // ================= RESET PASSWORD =================

  Future<bool> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/reset_password/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
      }),
    );

    return res.statusCode == 200;
  }
}

class AuthRequestException implements Exception {
  final String message;

  const AuthRequestException(this.message);

  @override
  String toString() => message;
}
