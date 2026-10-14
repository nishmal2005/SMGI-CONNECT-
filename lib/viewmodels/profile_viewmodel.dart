import 'dart:io';

import 'package:flutter/foundation.dart';

import '../core/network/api_exception.dart';
import '../data/repositories/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this._repo);
  final ProfileRepository _repo;

  // ── Stored fields ────────────────────────────────
  String _name = '';
  String _email = '';
  String _phone = '';

  /// Course split into two parts. Combined in the `course` getter.
  String _discipline = '';
  String _programName = '';

  /// Local file picked by the user (edit sheet).
  File? _avatarFile;

  /// Remote avatar URL from the server.
  String? _avatarUrl;

  // ── Loading / saving state ───────────────────────
  bool isLoading = false;
  bool saving = false;
  String? error;
  String? errorMessage;

  // ── Public getters ───────────────────────────────
  String get name => _name;
  String get email => _email;
  String get phone => _phone;

  /// Avatar — File (local pick) wins over server URL.
  /// Returned as `dynamic` so existing widgets that do
  /// `image is String` / `Image.file(image)` keep working.
  dynamic get avatar => _avatarFile ?? _avatarUrl;

  File? get avatarFile => _avatarFile;
  String? get avatarUrl => _avatarUrl;

  /// Formatted course string.
  /// Backend: { "discipline": "engineeRing", "program_name": "Mtech" }
  /// Returns: "engineeRing · Mtech"
  String get course {
    if (_discipline.isEmpty && _programName.isEmpty) return '';
    if (_discipline.isEmpty) return _programName;
    if (_programName.isEmpty) return _discipline;
    return '$_discipline · $_programName';
  }

  // ── Mutators (called from the edit sheet) ────────
  void updateName(String v) {
    _name = v;
    notifyListeners();
  }

  void updateEmail(String v) {
    _email = v;
    notifyListeners();
  }

  void updatePhone(String v) {
    _phone = v;
    notifyListeners();
  }

  void updateAvatar(File f) {
    _avatarFile = f;
    notifyListeners();
  }

  void clearAvatar() {
    _avatarFile = null;
    _avatarUrl = null;
    notifyListeners();
  }

  // ── Network: GET /profile/ ───────────────────────
  Future<void> load() async {
    if (isLoading) return;
    isLoading = true;
    error = null;
    errorMessage = null;
    notifyListeners();

    try {
      final res = await _repo.get();
      final obj = res.object;
      if (obj == null) return;

      // Unwrap { data: {...} } if present.
      final root = obj['data'] is Map
          ? Map<String, dynamic>.from(obj['data'] as Map)
          : obj;

      // ── Name: try every common key ───────────────
      _name = (root['name'] ??
              root['full_name'] ??
              root['user_name'] ??
              root['username'] ??
              root['first_name'] ??
              '')
          .toString();

      // ── Email ────────────────────────────────────
      _email = (root['email'] ?? root['user_email'] ?? '').toString();

      // ── Phone ────────────────────────────────────
      _phone = (root['phone'] ??
              root['contact_1'] ??
              root['mobile'] ??
              root['contact'])
          ?.toString() ??
          '';

      // ── Avatar ───────────────────────────────────
      _avatarUrl = (root['avatar'] ??
              root['image'] ??
              root['profile_image'])
          ?.toString();

      // ── Course ───────────────────────────────────
      final c = root['course'];
      if (c is Map) {
        final m = Map<String, dynamic>.from(c);
        _discipline = m['discipline']?.toString() ?? '';
        _programName = (m['program_name'] ??
                m['program'] ??
                m['course_name'])
            ?.toString() ??
            '';
      } else if (c is String) {
        _programName = c;
        _discipline = '';
      } else {
        _discipline = '';
        _programName = '';
      }

      // ── Debug: what actually came back ───────────
      if (kDebugMode) {
        debugPrint('[PROFILE] raw keys: ${root.keys.toList()}');
        debugPrint(
          '[PROFILE] name="$_name" email="$_email" '
          'discipline="$_discipline" program="$_programName" '
          'courseDisplay="$course"',
        );
      }
    } on ApiException catch (e) {
      error = e.message;
      errorMessage = e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Network: PATCH /profile/ ─────────────────────
  Future<bool> save() async {
    saving = true;
    error = null;
    errorMessage = null;
    notifyListeners();

    try {
      await _repo.update({
        'name': _name,
        'email': _email,
        'phone': _phone,
      });
      return true;
    } on ApiException catch (e) {
      error = e.message;
      errorMessage = e.message;
      return false;
    } finally {
      saving = false;
      notifyListeners();
    }
  }

  Future<void> reset() async {
    _name = '';
    _email = '';
    _phone = '';
    _discipline = '';
    _programName = '';
    _avatarFile = null;
    _avatarUrl = null;
    isLoading = false;
    saving = false;
    error = null;
    errorMessage = null;
    notifyListeners();
  }
}