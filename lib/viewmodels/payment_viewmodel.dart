import 'package:flutter/foundation.dart';
import 'package:smgi.connect/core/network/api_exception.dart';
import 'package:smgi.connect/data/models/payment_model.dart';
import 'package:smgi.connect/data/repositories/payment_repository.dart';



class PaymentViewModel extends ChangeNotifier {
  PaymentViewModel(this._repo);
  final PaymentRepository _repo;

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
      payments = res.results
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
}