import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api_exception.dart';
import '../data/models/document_status.dart';
import '../data/repositories/aadhaar_repository.dart';

class AadhaarViewModel extends ChangeNotifier {
  AadhaarViewModel(this._repo);
  final AadhaarRepository _repo;

  static const String _frontKey = 'aadhaar_front_status';
  static const String _backKey  = 'aadhaar_back_status';

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

  // ── Getters ─────────────────────────────────────
  String get aadhaar => _aadhaar;
  File?  get frontImage => _frontImage;
  File?  get backImage  => _backImage;
  DocumentStatus? get frontStatus => _frontStatus;
  DocumentStatus? get backStatus  => _backStatus;

  bool get isAadhaarValid => _aadhaar.length == 12;
  bool get isFrontUploaded => _frontImage != null;
  bool get isBackUploaded  => _backImage != null;
  bool get canContinue => isAadhaarValid && isFrontUploaded && isBackUploaded;

  bool get isLocked =>
      statusChecked &&
      ((_frontStatus?.isLocked ?? false) ||
       (_backStatus?.isLocked  ?? false));

  bool get needsReupload =>
      (_frontStatus?.canReupload ?? false) ||
      (_backStatus?.canReupload  ?? false);

  bool get frontNeedsReupload => _frontStatus?.canReupload ?? false;
  bool get backNeedsReupload  => _backStatus?.canReupload  ?? false;

  String get maskedAadhaar => _aadhaar.length < 12
      ? _aadhaar
      : 'XXXX XXXX ${_aadhaar.substring(8)}';

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

  // ── Local persistence ───────────────────────────
  Future<void> _saveStatusLocally() async {
    final prefs = await SharedPreferences.getInstance();

    if (_frontStatus != null) {
      await prefs.setString(_frontKey, _frontStatus!.name);
    } else {
      await prefs.remove(_frontKey);
    }

    if (_backStatus != null) {
      await prefs.setString(_backKey, _backStatus!.name);
    } else {
      await prefs.remove(_backKey);
    }

    if (kDebugMode) {
      debugPrint(
        '[AADHAAR] saved to prefs: '
        'front=$_frontStatus back=$_backStatus',
      );
    }
  }

  Future<void> _loadStatusLocally() async {
    final prefs = await SharedPreferences.getInstance();
    _frontStatus = parseDocumentStatus(prefs.getString(_frontKey));
    _backStatus  = parseDocumentStatus(prefs.getString(_backKey));
  }

  Future<void> _clearStatusLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_frontKey);
    await prefs.remove(_backKey);
  }

  // ── Status refresh (local cache + server) ───────
  Future<void> loadStatus({bool force = false}) async {
    if (loadingStatus) return;
    loadingStatus = true;
    notifyListeners();

    try {
      // 1. Fast paint from cache so the form shows instantly.
      await _loadStatusLocally();
      if (kDebugMode) {
        debugPrint(
          '[AADHAAR] loadStatus from prefs: '
          'front=$_frontStatus back=$_backStatus',
        );
      }
      notifyListeners();

      if (!force && statusChecked) return;

      // 2. Trust the server.
      try {
        final res = await _repo.status();
        await _applyStatusResponse(res.object);
        errorMessage = null;
      } on ApiException catch (e) {
        if (e.statusCode == 404) {
          // Server has NO Aadhaar on file → local cache is stale.
          // Clear it so the form renders fresh instead of
          // showing "already submitted and under review".
          _frontStatus = null;
          _backStatus  = null;
          await _clearStatusLocally();
          errorMessage = null;
          if (kDebugMode) {
            debugPrint(
              '[AADHAAR] server 404 → cleared local status cache',
            );
          }
        } else {
          errorMessage = e.message;
        }
      }
    } finally {
      statusChecked = true;
      loadingStatus = false;
      if (kDebugMode) {
        debugPrint(
          '[AADHAAR] final front=$_frontStatus back=$_backStatus '
          'locked=$isLocked',
        );
      }
      notifyListeners();
    }
  }

  // ── POST /aadhaar/upload/ ───────────────────────
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
        back:  _backImage!,
      );
      await _applyStatusResponse(res.object, fallbackToPending: true);
      return true;
    } on ApiException catch (e) {
      errorMessage = _friendlyError(e.message);
      await _inferReuploadFromError(e.message);
      return false;
    } finally {
      uploading = false;
      notifyListeners();
    }
  }

  // ── PATCH /aadhaar/ ─────────────────────────────
  Future<bool> reuploadSide({
    required String side,
    required File file,
  }) async {
    uploading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final res = await _repo.reuploadSide(side: side, file: file);
      await _applyStatusResponse(res.object);
      return true;
    } on ApiException catch (e) {
      errorMessage = _friendlyError(e.message);
      return false;
    } finally {
      uploading = false;
      notifyListeners();
    }
  }

  // ── Helpers ─────────────────────────────────────
  /// Only updates fields actually present in the response, unless
  /// [fallbackToPending] is true (i.e. after a fresh POST where both
  /// sides are guaranteed to exist). If the server omits a side and
  /// this isn't a POST, we treat that side as "not uploaded" and null
  /// it out — this is what prevents stale local cache from lying.
  Future<void> _applyStatusResponse(
    Map<String, dynamic>? json, {
    bool fallbackToPending = false,
  }) async {
    if (json == null) return;

    if (kDebugMode) {
      debugPrint('[AADHAAR] _applyStatusResponse got: $json');
    }

    final data = json['data'];
    final map  = data is Map ? Map<String, dynamic>.from(data) : json;

    // Support both nested and flat shapes from the backend.
    final f    = map['front_status']?.toString();
    final b    = map['back_status']?.toString();
    final altF = map['aadhaar_front_status']?.toString();
    final altB = map['aadhaar_back_status']?.toString();

    final frontRaw = (f != null && f.isNotEmpty) ? f : altF;
    final backRaw  = (b != null && b.isNotEmpty) ? b : altB;

    if (frontRaw != null && frontRaw.isNotEmpty) {
      _frontStatus = parseDocumentStatus(frontRaw);
    } else if (fallbackToPending) {
      _frontStatus = DocumentStatus.pending;
    } else {
      _frontStatus = null;
    }

    if (backRaw != null && backRaw.isNotEmpty) {
      _backStatus = parseDocumentStatus(backRaw);
    } else if (fallbackToPending) {
      _backStatus = DocumentStatus.pending;
    } else {
      _backStatus = null;
    }

    statusChecked = true;

    if (kDebugMode) {
      debugPrint(
        '[AADHAAR] parsed front=$_frontStatus back=$_backStatus',
      );
    }

    await _saveStatusLocally();
  }

  /// Parse backend error strings like "…use PATCH for front…" and
  /// mark the affected side(s) as reupload locally.
  Future<void> _inferReuploadFromError(String raw) async {
    final lower = raw.toLowerCase();
    if (!lower.contains('use patch')) return;

    bool changed = false;
    if (lower.contains('front')) {
      _frontStatus = DocumentStatus.reupload;
      changed = true;
    }
    if (lower.contains('back')) {
      _backStatus = DocumentStatus.reupload;
      changed = true;
    }
    if (!changed) {
      // Ambiguous — mark both so the user sees both tiles.
      _frontStatus = DocumentStatus.reupload;
      _backStatus  = DocumentStatus.reupload;
    }

    statusChecked = true;
    await _saveStatusLocally();
  }

  String _friendlyError(String raw) {
    final lower = raw.toLowerCase();

    if (lower.contains('pending') && lower.contains('cannot be replaced')) {
      return 'Your Aadhaar is already under review. You can re-upload '
          'only after the admin flags a side for re-upload.';
    }
    if (lower.contains('use patch') && lower.contains('re-upload')) {
      return 'Your Aadhaar is already on file. Please re-upload the '
          'flagged side below.';
    }
    if (lower.contains('verified') && lower.contains('cannot')) {
      return 'Your Aadhaar is already verified. It cannot be replaced.';
    }
    if (lower.contains('at least one') && lower.contains('image')) {
      return 'Please attach both front and back images.';
    }
    return raw;
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
    await _clearStatusLocally();
    notifyListeners();
  }
}