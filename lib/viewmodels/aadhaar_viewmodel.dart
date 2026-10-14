import 'dart:io';

import 'package:flutter/foundation.dart';

import '../core/network/api_exception.dart';
import '../data/models/document_model.dart';
import '../data/repositories/aadhaar_repository.dart';

class AadhaarViewModel extends ChangeNotifier {
  AadhaarViewModel(this._repo);
  final AadhaarRepository _repo;

  // ── Input state ─────────────────────────────────
  String _aadhaar = '';
  File? _frontImage;
  File? _backImage;

  // ── Server state ────────────────────────────────
  DocumentStatus? _frontStatus;
  DocumentStatus? _backStatus;

  bool uploading = false;
  bool loadingStatus = false;
  bool statusChecked = false;
  String? errorMessage;

  String get aadhaar => _aadhaar;
  File? get frontImage => _frontImage;
  File? get backImage => _backImage;
  DocumentStatus? get frontStatus => _frontStatus;
  DocumentStatus? get backStatus => _backStatus;

  bool get isAadhaarValid => _aadhaar.length == 12;
  bool get isFrontUploaded => _frontImage != null;
  bool get isBackUploaded => _backImage != null;
  bool get canContinue => isAadhaarValid && isFrontUploaded && isBackUploaded;

  bool get isLocked {
    if (!statusChecked) return false;
    bool locked(DocumentStatus? s) =>
        s == DocumentStatus.pending || s == DocumentStatus.verified;
    return locked(_frontStatus) || locked(_backStatus);
  }

  bool get needsReupload =>
      _frontStatus == DocumentStatus.reupload ||
      _frontStatus == DocumentStatus.rejected ||
      _backStatus == DocumentStatus.reupload ||
      _backStatus == DocumentStatus.rejected;

  bool get frontNeedsReupload =>
      _frontStatus == DocumentStatus.reupload ||
      _frontStatus == DocumentStatus.rejected;

  bool get backNeedsReupload =>
      _backStatus == DocumentStatus.reupload ||
      _backStatus == DocumentStatus.rejected;

  String get maskedAadhaar {
    if (_aadhaar.length < 12) return _aadhaar;
    return 'XXXX XXXX ${_aadhaar.substring(8)}';
  }

  // ── Setters ─────────────────────────────────────
  void setAadhaar(String v) {
    _aadhaar = v;
    notifyListeners();
  }

  void setFrontImage(File f) {
    _frontImage = f;
    notifyListeners();
  }

  void setBackImage(File f) {
    _backImage = f;
    notifyListeners();
  }

  // ── Status refresh (in-memory only) ─────────────
  Future<void> loadStatus() async {
    if (loadingStatus) return;
    loadingStatus = true;
    notifyListeners();
    try {
      statusChecked = true;
      errorMessage = null;
      if (kDebugMode) {
        debugPrint(
          '[AADHAAR] status: front=$_frontStatus back=$_backStatus',
        );
      }
    } finally {
      loadingStatus = false;
      notifyListeners();
    }
  }

  // ── First-time upload (POST both sides) ─────────
  Future<bool> upload() async {
    if (!canContinue) {
      errorMessage = 'Fill Aadhaar number and both images first.';
      notifyListeners();
      return false;
    }

    uploading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final frontRes = await _repo.uploadFront(
        aadhaarNumber: _aadhaar,
        file: _frontImage!,
      );
      _applyFront(frontRes.object);

      final backRes = await _repo.uploadBack(
        aadhaarNumber: _aadhaar,
        file: _backImage!,
      );
      _applyBack(backRes.object);

      statusChecked = true;
      return true;
    } on ApiException catch (e) {
      errorMessage = _friendlyError(e.message);

      final lower = e.message.toLowerCase();
      if (lower.contains('use patch') || lower.contains('re-upload')) {
        if (lower.contains('front')) {
          _frontStatus ??= DocumentStatus.reupload;
        }
        if (lower.contains('back')) {
          _backStatus ??= DocumentStatus.reupload;
        }
        if (_frontStatus == null && _backStatus == null) {
          _frontStatus = DocumentStatus.reupload;
          _backStatus = DocumentStatus.reupload;
        }
        statusChecked = true;
      }
      return false;
    } finally {
      uploading = false;
      notifyListeners();
    }
  }

  // ── Reupload one side (PATCH) ───────────────────
  Future<bool> reuploadFront({required File file}) async {
    uploading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final res = await _repo.reuploadFront(file: file);
      _applyFront(res.object);
      statusChecked = true;
      return true;
    } on ApiException catch (e) {
      errorMessage = _friendlyError(e.message);
      return false;
    } finally {
      uploading = false;
      notifyListeners();
    }
  }

  Future<bool> reuploadBack({required File file}) async {
    uploading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final res = await _repo.reuploadBack(file: file);
      _applyBack(res.object);
      statusChecked = true;
      return true;
    } on ApiException catch (e) {
      errorMessage = _friendlyError(e.message);
      return false;
    } finally {
      uploading = false;
      notifyListeners();
    }
  }

  // ── Response parsing ────────────────────────────
  void _applyFront(Map<String, dynamic>? json) {
    _frontStatus = _statusFrom(json) ?? DocumentStatus.pending;
  }

  void _applyBack(Map<String, dynamic>? json) {
    _backStatus = _statusFrom(json) ?? DocumentStatus.pending;
  }

  DocumentStatus? _statusFrom(Map<String, dynamic>? json) {
    if (json == null) return null;
    final data = json['data'];
    final map = data is Map ? Map<String, dynamic>.from(data) : json;

    final raw = map['status']?.toString() ??
        map['front_status']?.toString() ??
        map['back_status']?.toString();
    return _parseStatus(raw);
  }

  String _friendlyError(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('pending') && lower.contains('cannot be replaced')) {
      return 'Your Aadhaar is already under review. You can re-upload '
          'only after the admin flags a side for re-upload.';
    }
    if (lower.contains('use patch') || lower.contains('re-upload')) {
      return 'Your Aadhaar is already on file. Please re-upload the '
          'flagged side below.';
    }
    if (lower.contains('verified') && lower.contains('cannot')) {
      return 'Your Aadhaar is already verified. It cannot be replaced.';
    }
    return raw;
  }

  DocumentStatus? _parseStatus(String? v) {
    if (v == null || v.isEmpty) return null;
    switch (v.toLowerCase().replaceAll('_', '')) {
      case 'verified':
      case 'approved':
        return DocumentStatus.verified;
      case 'rejected':
        return DocumentStatus.rejected;
      case 'reuploadrequired':
      case 'reupload':
      case 'reuploadneeded':
        return DocumentStatus.reupload;
      case 'pending':
      case 'inreview':
      case 'underreview':
      default:
        return DocumentStatus.pending;
    }
  }

  Future<void> reset() async {
    _aadhaar = '';
    _frontImage = null;
    _backImage = null;
    _frontStatus = null;
    _backStatus = null;
    statusChecked = false;
    uploading = false;
    loadingStatus = false;
    errorMessage = null;
    notifyListeners();
  }
}