import 'dart:io';

import 'package:flutter/foundation.dart';

import '../core/network/api_exception.dart';
import '../data/repositories/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this._repo);
  final ProfileRepository _repo;

  // ── Profile fields ──────────────────────────────
  String _name = '';
  String _email = '';
  String _phone = '';
  String _course = '';
  File? _avatar;

  // ── Load / save state ───────────────────────────
  bool isLoading = false;
  bool saving = false;
  String? errorMessage;
  String? saveError;

  // ── Getters ─────────────────────────────────────
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get course => _course;
  File? get avatar => _avatar;

  /// Legacy alias — kept so existing screens using `vm.error` still work.
  String? get error => saveError;

  // ── GET /profile/ ───────────────────────────────
  Future<void> load() async {
    if (isLoading) return;
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final res = await _repo.get();
      final data = res.object ?? const <String, dynamic>{};

      _name = _firstNonEmpty(
        [data['full_name'], data['name']],
        fallback: _name,
      );
      _email = _str(data['email'], fallback: _email);
      _phone = _str(
        data['contact_1'] ?? data['phone'] ?? data['mobile'],
        fallback: _phone,
      );
      _course = _str(
        data['course_name'] ?? data['course'],
        fallback: _course,
      );
    } on ApiException catch (e) {
      errorMessage = e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Local edits ─────────────────────────────────
  void updateName(String v) {
    if (_name == v) return;
    _name = v;
    notifyListeners();
  }

  void updateEmail(String v) {
    if (_email == v) return;
    _email = v;
    notifyListeners();
  }

  void updatePhone(String v) {
    if (_phone == v) return;
    _phone = v;
    notifyListeners();
  }

  void updateCourse(String v) {
    if (_course == v) return;
    _course = v;
    notifyListeners();
  }

  void updateAvatar(File? file) {
    _avatar = file;
    notifyListeners();
  }

  void clearAvatar() {
    _avatar = null;
    notifyListeners();
  }

  // ── PATCH /profile/ ─────────────────────────────
  Future<bool> save() async {
    saving = true;
    saveError = null;
    notifyListeners();

    try {
      final body = <String, dynamic>{
        'full_name': _name.trim(),
        'email': _email.trim(),
        'contact_1': _digitsOnly(_phone),
      };

      await _repo.update(body);
      return true;
    } on ApiException catch (e) {
      saveError = e.message;
      return false;
    } finally {
      saving = false;
      notifyListeners();
    }
  }

  // ── Helpers ─────────────────────────────────────
  String _str(dynamic v, {required String fallback}) {
    if (v == null) return fallback;
    final s = v.toString().trim();
    return s.isEmpty ? fallback : s;
  }

  String _firstNonEmpty(List<dynamic> values, {required String fallback}) {
    for (final v in values) {
      if (v == null) continue;
      final s = v.toString().trim();
      if (s.isNotEmpty) return s;
    }
    return fallback;
  }

  String _digitsOnly(String raw) => raw.replaceAll(RegExp(r'\D'), '');
}