

// lib/data/repositories/payment_repository.dart

import 'package:smgi_connect/core/constants/api_endpoints.dart';
import 'package:smgi_connect/core/network/api_client.dart';
import 'package:smgi_connect/core/network/api_exception.dart';
import 'package:smgi_connect/data/models/payment_model.dart';

class PaymentRepository {
  PaymentRepository(this._client);

  final ApiClient _client;

  // ── 1. Check payment amount / readiness ───────────────────
  Future<PaymentSummaryModel> getPaymentSummary(String applicationId) async {
    try {
      final res = await _client.get(
        ApiEndpoints.applicationPaymentSummary(applicationId),
      );
      return PaymentSummaryModel.fromJson(_asMap(res));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to load payment summary: $e');
    }
  }

  // ── 2. Create or reuse checkout session ───────────────────
  Future<PaymentInitiateModel> initiatePayment(String applicationId) async {
    try {
      final res = await _client.post(
        ApiEndpoints.applicationPaymentInitiate(applicationId),
        body: const {},
      );
      return PaymentInitiateModel.fromJson(_asMap(res));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to initiate payment: $e');
    }
  }

  // ── 3. Check verified payment status ──────────────────────
  Future<PaymentStatusModel> getPaymentStatus(
    String applicationId,
    String orderId,
  ) async {
    try {
      final res = await _client.get(
        ApiEndpoints.applicationPaymentStatus(applicationId),
        query: {'order_id': orderId},
      );
      return PaymentStatusModel.fromJson(_asMap(res));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to fetch payment status: $e');
    }
  }

  // ── 4. Retrieve confirmed payment details ─────────────────
  Future<PaymentSuccessModel> getPaymentSuccess(String applicationId) async {
    try {
      final res = await _client.get(
        ApiEndpoints.applicationPaymentSuccess(applicationId),
      );
      return PaymentSuccessModel.fromJson(_asMap(res));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to fetch payment success details: $e');
    }
  }

  // ── Existing history endpoint ─────────────────────────────
  Future<dynamic> history() async {
    return _client.get(ApiEndpoints.paymentsHistory);
  }

  // ── Helpers ───────────────────────────────────────────────
  Map<String, dynamic> _asMap(dynamic res) {
    if (res is Map<String, dynamic>) return res;
    if (res is Map) return Map<String, dynamic>.from(res);
    throw ApiException('Unexpected response format');
  }
}