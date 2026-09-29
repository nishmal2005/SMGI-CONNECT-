import 'package:flutter/foundation.dart';
import 'package:smgi.connect/core/network/api_exception.dart';
import 'package:smgi.connect/data/models/referral_model.dart';
import 'package:smgi.connect/data/repositories/referral_repository.dart';


class ReferralViewModel extends ChangeNotifier {
  ReferralViewModel(this._repo);
  final ReferralRepository _repo;

  bool isLoading = false;
  bool isApplying = false;
  String? errorMessage;

  ReferralModel? previewReferral;
  ReferralModel? appliedReferral;
  List<ReferralModel> history = const [];

  bool get hasPreview => previewReferral != null;
  bool get hasApplied => appliedReferral != null;

  // ── POST /referrals/validate/ ────────────────────
  Future<bool> validate(String code) async {
    if (code.trim().isEmpty) return false;
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final res = await _repo.validate(code.trim());
      final obj = res.object;
      previewReferral = obj != null ? ReferralModel.fromJson(obj) : null;
      return previewReferral != null;
    } on ApiException catch (e) {
      errorMessage = e.message;
      previewReferral = null;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── POST /referrals/apply/ ───────────────────────
  /// [applicationId] is required by the backend.
  Future<bool> apply({
    required String code,
    required int applicationId,
  }) async {
    if (code.trim().isEmpty) return false;
    isApplying = true;
    errorMessage = null;
    notifyListeners();
    try {
      final res = await _repo.apply(
        code: code.trim(),
        applicationId: applicationId,
      );
      final obj = res.object;
      appliedReferral = obj != null ? ReferralModel.fromJson(obj) : null;
      return appliedReferral != null;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } finally {
      isApplying = false;
      notifyListeners();
    }
  }

  // ── GET /referrals/history/ ──────────────────────
  Future<void> loadHistory() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final res = await _repo.history();
      history = res.results
          .whereType<Map>()
          .map((e) => ReferralModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on ApiException catch (e) {
      errorMessage = e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearApplied() {
    appliedReferral = null;
    previewReferral = null;
    errorMessage = null;
    notifyListeners();
  }
}