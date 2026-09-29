import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_response.dart';

class ApplicationRepository {
  ApplicationRepository(this._client);
  final ApiClient _client;

  Future<ApiResponse> create(Map<String, dynamic> body) async =>
      ApiResponse(await _client.post(ApiEndpoints.createApplication, body: body));

  Future<ApiResponse> status() async =>
      ApiResponse(await _client.get(ApiEndpoints.applicationStatus));

  Future<ApiResponse> review(String id) async =>
      ApiResponse(await _client.get(ApiEndpoints.applicationReview(id)));

  Future<ApiResponse> confirmReview(String id, Map<String, dynamic> body) async =>
      ApiResponse(await _client.post(
          ApiEndpoints.applicationReviewConfirm(id), body: body));

  Future<ApiResponse> paymentSummary(String id) async =>
      ApiResponse(await _client.get(ApiEndpoints.applicationPaymentSummary(id)));

  Future<ApiResponse> paymentSuccess(String id) async =>
      ApiResponse(await _client.get(ApiEndpoints.applicationPaymentSuccess(id)));

  Future<ApiResponse> acknowledgment(String id) async =>
      ApiResponse(await _client.get(ApiEndpoints.applicationAcknowledgment(id)));
}