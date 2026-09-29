import '../../core/network/api_client.dart';
import '../../core/network/api_response.dart';
import '../../core/constants/api_endpoints.dart';

class AuthRepository {
  AuthRepository(this._client);
  final ApiClient _client;

  Future<ApiResponse> sendOtp(String email) async =>
      ApiResponse(await _client.post(ApiEndpoints.sendOtp,
          body: {'email': email}, authenticated: false));

  Future<ApiResponse> resendOtp(String email) async =>
      ApiResponse(await _client.post(ApiEndpoints.resendOtp,
          body: {'email': email}, authenticated: false));

  Future<ApiResponse> verifyOtp(String email, String otp) async =>
      ApiResponse(await _client.post(ApiEndpoints.verifyOtp,
          body: {'email': email, 'otp': otp}, authenticated: false));

  Future<ApiResponse> register({
    required String email,
    required String password,
    required String confirmPassword,
  }) async =>
      ApiResponse(await _client.post(ApiEndpoints.register, body: {
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
      }, authenticated: false));

  Future<ApiResponse> login({
    required String email,
    required String password,
  }) async {
    final res = ApiResponse(await _client.post(
      ApiEndpoints.login,
      body: {'email': email, 'password': password},
      authenticated: false,
    ));
    final access = res.object?['access']?.toString();
    final refresh = res.object?['refresh']?.toString();
    if (access != null && refresh != null) {
      await _client.saveTokens(access: access, refresh: refresh);
    }
    return res;
  }

  Future<ApiResponse> logout() async {
    try {
      return ApiResponse(await _client.post(ApiEndpoints.logout, body: {}));
    } finally {
      await _client.clearTokens();
    }
  }

  Future<ApiResponse> passwordReset(String email) async =>
      ApiResponse(await _client.post(ApiEndpoints.passwordReset,
          body: {'email': email}, authenticated: false));

  Future<ApiResponse> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) async =>
      ApiResponse(await _client.post(ApiEndpoints.resetPassword, body: {
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
      }, authenticated: false));

  Future<ApiResponse> changePassword(Map<String, dynamic> body) async =>
      ApiResponse(await _client.post(ApiEndpoints.changePassword, body: body));
}