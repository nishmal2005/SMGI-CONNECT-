import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_response.dart';

class ReferralRepository {
  ReferralRepository(this._client);
  final ApiClient _client;

  Future<ApiResponse> validate(String code) async =>
      ApiResponse(await _client.post(
        ApiEndpoints.referralValidate,
        body: {'code': code},
      ));

 
  Future<ApiResponse> apply({
    required String code,
    required int applicationId,
  }) async =>
      ApiResponse(await _client.post(
        ApiEndpoints.referralApply,
        body: {
          'code': code,
          'application_id': applicationId,
        },
      ));

  /// GET /referrals/history/
  Future<ApiResponse> history() async =>
      ApiResponse(await _client.get(ApiEndpoints.referralHistory));
}