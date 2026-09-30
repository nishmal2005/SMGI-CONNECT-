import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  AuthRepository(this._client);
  final ApiClient _client;

  static const String _onboardingKey = 'has_seen_onboarding';

  // ── Auth state helpers ──────────────────────────
  Future<bool> isLoggedIn() => _client.isLoggedIn;

  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> markOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  // ── Auth endpoints ──────────────────────────────

  Future<ApiResponse> sendOtp(String email) async =>
      ApiResponse(await _client.post(
        ApiEndpoints.sendOtp,
        body: {'email': email},
        authenticated: false,
      ));

  Future<ApiResponse> resendOtp(String email) async =>
      ApiResponse(await _client.post(
        ApiEndpoints.resendOtp,
        body: {'email': email},
        authenticated: false,
      ));

  Future<ApiResponse> verifyOtp(String email, String otp) async =>
      ApiResponse(await _client.post(
        ApiEndpoints.verifyOtp,
        body: {'email': email, 'otp': otp},
        authenticated: false,
      ));

  Future<ApiResponse> register({
    required String email,
    required String password,
    required String confirmPassword,
  }) async =>
      ApiResponse(await _client.post(
        ApiEndpoints.register,
        body: {
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
        },
        authenticated: false,
      ));

  /// POST /login/
  ///
  /// Accepts both `access`/`refresh` and `access_token`/`refresh_token`.
  Future<ApiResponse> login({
    required String email,
    required String password,
  }) async {
    final res = ApiResponse(await _client.post(
      ApiEndpoints.login,
      body: {'email': email, 'password': password},
      authenticated: false,
    ));

    final obj = res.object;
    if (obj == null) return res;

    final access = (obj['access'] ??
            obj['access_token'] ??
            obj['token'])
        ?.toString();
    final refresh = (obj['refresh'] ?? obj['refresh_token'])?.toString();

    if (access != null &&
        access.isNotEmpty &&
        refresh != null &&
        refresh.isNotEmpty) {
      await _client.saveTokens(access: access, refresh: refresh);
    }
    return res;
  }

  Future<void> logout() async {
    final refresh = await _client.refreshToken;

    try {
      if (refresh != null && refresh.isNotEmpty) {
        await _client.post(
          ApiEndpoints.logout,
          body: {'refresh': refresh},
        );
      }
    } on ApiException {
      // Swallow — local logout must succeed regardless.
    } finally {
      await _client.clearTokens();
    }
  }

  Future<ApiResponse> passwordReset(String email) async =>
      ApiResponse(await _client.post(
        ApiEndpoints.passwordReset,
        body: {'email': email},
        authenticated: false,
      ));

  Future<ApiResponse> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) async =>
      ApiResponse(await _client.post(
        ApiEndpoints.resetPassword,
        body: {
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
        },
        authenticated: false,
      ));

  Future<ApiResponse> changePassword(Map<String, dynamic> body) async =>
      ApiResponse(await _client.post(
        ApiEndpoints.changePassword,
        body: body,
      ));
}