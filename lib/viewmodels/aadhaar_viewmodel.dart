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
  DocumentStatus _frontStatus = DocumentStatus.pending;
  DocumentStatus _backStatus = DocumentStatus.pending;

  bool uploading = false;
  String? errorMessage;

  String get aadhaar => _aadhaar;
  File? get frontImage => _frontImage;
  File? get backImage => _backImage;
  DocumentStatus get frontStatus => _frontStatus;
  DocumentStatus get backStatus => _backStatus;

  bool get isAadhaarValid => _aadhaar.length == 12;
  bool get isFrontUploaded => _frontImage != null;
  bool get isBackUploaded => _backImage != null;
  bool get canContinue => isAadhaarValid && isFrontUploaded && isBackUploaded;

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

  void setStatuses({
    required DocumentStatus front,
    required DocumentStatus back,
  }) {
    _frontStatus = front;
    _backStatus = back;
    notifyListeners();
  }

  // ── POST /aadhaar/upload/ (first upload) ────────
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
      final res = await _repo.upload(
        aadhaarNumber: _aadhaar,
        front: _frontImage!,
        back: _backImage!,
      );
      _applyStatusResponse(res.object);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } finally {
      uploading = false;
      notifyListeners();
    }
  }

  // ── PATCH /aadhaar/ (re-upload one side) ────────
  Future<bool> reuploadSide({
    required String side,       // 'front' | 'back'
    required File file,
  }) async {
    uploading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final res = await _repo.reuploadSide(side: side, file: file);
      _applyStatusResponse(res.object);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } finally {
      uploading = false;
      notifyListeners();
    }
  }

  /// Parse `{ success, message, data: { front_status, back_status } }`.
  void _applyStatusResponse(Map<String, dynamic>? json) {
    if (json == null) return;
    final data = json['data'];
    final map = data is Map ? Map<String, dynamic>.from(data) : json;

    final f = map['front_status']?.toString();
    final b = map['back_status']?.toString();
    if (f != null) _frontStatus = _parseStatus(f);
    if (b != null) _backStatus = _parseStatus(b);
  }

  DocumentStatus _parseStatus(String v) {
    switch (v.toLowerCase().replaceAll('_', '')) {
      case 'verified':
      case 'approved':
        return DocumentStatus.verified;
      case 'rejected':
        return DocumentStatus.rejected;
      case 'reuploadrequired':
      case 'reupload':
        return DocumentStatus.reupload;
      default:
        return DocumentStatus.pending;
    }
  }

  void reset() {
    _aadhaar = '';
    _frontImage = null;
    _backImage = null;
    _frontStatus = DocumentStatus.pending;
    _backStatus = DocumentStatus.pending;
    uploading = false;
    errorMessage = null;
    notifyListeners();
  }
}