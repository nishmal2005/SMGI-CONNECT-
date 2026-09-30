import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_response.dart';

class ProfileRepository {
  ProfileRepository(this._client);
  final ApiClient _client;

  /// GET /profile/
  Future<ApiResponse> get() async =>
      ApiResponse(await _client.get(ApiEndpoints.profile));

  /// POST /profile/
  ///
  /// Full create / overwrite. Used by the admission Personal Details step.
  Future<ApiResponse> save(Map<String, dynamic> body) async =>
      ApiResponse(await _client.post(ApiEndpoints.profile, body: body));

  /// PATCH /profile/
  ///
  /// Partial update. Used by the profile edit sheet.
  Future<ApiResponse> update(Map<String, dynamic> body) async =>
      ApiResponse(await _client.patch(ApiEndpoints.profile, body: body));
}