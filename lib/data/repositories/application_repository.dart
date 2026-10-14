import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_response.dart';

class ApplicationRepository {
  ApplicationRepository(this._client);
  final ApiClient _client;

  /// POST /applications/
  Future<ApiResponse> create(Map<String, dynamic> body) async =>
      ApiResponse(await _client.post(
        ApiEndpoints.createApplication,
        body: body,
      ));

  /// GET /applications/status/
  Future<ApiResponse> status() async =>
      ApiResponse(await _client.get(ApiEndpoints.applicationStatus));

  /// GET /applications/{id}/review/
  Future<ApiResponse> review(String id) async =>
      ApiResponse(await _client.get(ApiEndpoints.applicationReview(id)));

  /// POST /applications/{id}/review/confirm/
  Future<ApiResponse> confirmReview(
    String id, {
    required bool confirmed,
  }) async =>
      ApiResponse(await _client.post(
        ApiEndpoints.applicationReviewConfirm(id),
        body: {'confirmed': confirmed},
      ));

  /// GET /applications/{id}/payment-summary/
  Future<ApiResponse> paymentSummary(String id) async =>
      ApiResponse(await _client.get(
        ApiEndpoints.applicationPaymentSummary(id),
      ));

  /// GET /applications{id}/payment-success/
  Future<ApiResponse> paymentSuccess(String id) async =>
      ApiResponse(await _client.get(
        ApiEndpoints.applicationPaymentSuccess(id),
      ));

  /// GET /applications/{id}/admission-acknowledgment/
  Future<List<int>> acknowledgment(String id) =>
      _client.getBytes(ApiEndpoints.applicationAcknowledgment(id));
}