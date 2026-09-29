import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_response.dart';

class PaymentRepository {
  PaymentRepository(this._client);
  final ApiClient _client;

  /// GET /payments/history/
  /// Returns the authenticated student's payment records.
  Future<ApiResponse> history() async =>
      ApiResponse(await _client.get(ApiEndpoints.paymentsHistory));

  /// GET /applications/<id>/payment-summary/
  Future<ApiResponse> summaryFor(String applicationId) async =>
      ApiResponse(await _client.get(
        ApiEndpoints.applicationPaymentSummary(applicationId),
      ));

  /// GET /applications/<id>/payment-success/
  Future<ApiResponse> successFor(String applicationId) async =>
      ApiResponse(await _client.get(
        ApiEndpoints.applicationPaymentSuccess(applicationId),
      ));
}