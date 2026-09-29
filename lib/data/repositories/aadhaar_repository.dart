import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_response.dart';

class ProfileRepository {
  ProfileRepository(this._client);
  final ApiClient _client;

  Future<ApiResponse> uploadAadhaar(Map<String, dynamic> body) async =>
      ApiResponse(await _client.post(ApiEndpoints.aadhaarUpload, body: body));

  Future<ApiResponse> saveProfile(Map<String, dynamic> body) async =>
      ApiResponse(await _client.post(ApiEndpoints.profile, body: body));
}