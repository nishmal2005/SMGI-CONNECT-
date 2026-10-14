// lib/viewmodels/payment_view_model.dart

import 'package:flutter/foundation.dart';
import 'package:smgi_connect/core/network/api_exception.dart';
import 'package:smgi_connect/data/models/payment_model.dart';
import 'package:smgi_connect/data/repositories/payment_repository.dart';

enum PaymentFlowState {
  idle,
  loadingSummary,
  summaryReady,
  initiating,
  checkoutOpen,
  verifying,
  success,
  failure,
}

class PaymentViewModel extends ChangeNotifier {
  PaymentViewModel(this._repo);

  final PaymentRepository _repo;

  // ── History state ─────────────────────────────────────────
  bool isLoading = false;
  String? errorMessage;
  List<PaymentModel> payments = const [];
  String query = '';

  List<PaymentModel> get filtered {
    if (query.trim().isEmpty) return payments;
    final q = query.toLowerCase();
    return payments.where((p) {
      return p.title.toLowerCase().contains(q) ||
          p.status.toLowerCase().contains(q) ||
          p.amount.toLowerCase().contains(q) ||
          p.transactionId.toLowerCase().contains(q);
    }).toList();
  }

  void setQuery(String value) {
    query = value;
    notifyListeners();
  }

  Future<void> loadHistory() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final res = await _repo.history();
      payments = (res.results as List)
          .whereType<Map>()
          .map((e) => PaymentModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on ApiException catch (e) {
      errorMessage = e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Payment flow state ────────────────────────────────────
  PaymentFlowState state = PaymentFlowState.idle;
  PaymentSummaryModel? summary;
  PaymentInitiateModel? checkout;
  PaymentSuccessModel? successDetails;
  String? flowError;

  Future<bool> loadSummary(String applicationId) async {
    state = PaymentFlowState.loadingSummary;
    flowError = null;
    notifyListeners();
    try {
      final result = await _repo.getPaymentSummary(applicationId);
      summary = result;
      state = PaymentFlowState.summaryReady;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      flowError = e.message;
      state = PaymentFlowState.failure;
      notifyListeners();
      return false;
    }
  }

  Future<PaymentInitiateModel?> startCheckout(String applicationId) async {
    state = PaymentFlowState.initiating;
    flowError = null;
    notifyListeners();
    try {
      checkout = await _repo.initiatePayment(applicationId);
      state = PaymentFlowState.checkoutOpen;
      notifyListeners();
      return checkout;
    } on ApiException catch (e) {
      flowError = e.message;
      state = PaymentFlowState.failure;
      notifyListeners();
      return null;
    }
  }

  Future<bool> verifyPayment(String applicationId, String orderId) async {
    state = PaymentFlowState.verifying;
    notifyListeners();
    try {
      for (var i = 0; i < 4; i++) {
        final status = await _repo.getPaymentStatus(applicationId, orderId);
        if (status.isPaid) {
          successDetails = await _repo.getPaymentSuccess(applicationId);
          state = PaymentFlowState.success;
          notifyListeners();
          return true;
        }
        if (status.isFailed) {
          flowError = 'Payment was not completed. You can try again.';
          state = PaymentFlowState.failure;
          notifyListeners();
          return false;
        }
        if (i < 3) {
          await Future.delayed(Duration(seconds: 2 * (i + 1)));
        }
      }
      flowError = 'Payment not verified yet. Please check back shortly.';
      state = PaymentFlowState.failure;
      notifyListeners();
      return false;
    } on ApiException catch (e) {
      flowError = e.message;
      state = PaymentFlowState.failure;
      notifyListeners();
      return false;
    }
  }

  void markFailure(String message) {
    flowError = message;
    state = PaymentFlowState.failure;
    notifyListeners();
  }

  void reset() {
    state = PaymentFlowState.idle;
    summary = null;
    checkout = null;
    successDetails = null;
    flowError = null;
    notifyListeners();
  }
}


