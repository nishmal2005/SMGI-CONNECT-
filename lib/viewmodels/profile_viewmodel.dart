import 'dart:io';

import 'package:flutter/foundation.dart';

class ProfileViewModel extends ChangeNotifier {
  // ── Fields (would normally come from GET /profile/) ──
  String _name = 'Cooper, Kristin';
  String _email = 'user.email@example.com';
  String _phone = '+91 9904703101';
  String _course = 'BSc Nursing';
  File? _avatar;

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get course => _course;
  File? get avatar => _avatar;

  // ── Editing state ────────────────────────────────
  bool _saving = false;
  String? _error;
  bool get saving => _saving;
  String? get error => _error;

  // ── Mutations ────────────────────────────────────
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

  void updateAvatar(File? file) {
    _avatar = file;
    notifyListeners();
  }

  void clearAvatar() {
    _avatar = null;
    notifyListeners();
  }

  // ── Save (stub until POST /profile/ is wired) ────
  Future<bool> save() async {
    _saving = true;
    _error = null;
    notifyListeners();
    try {
      // TODO: ProfileRepository.saveProfile({
      //   'name': _name, 'email': _email, 'phone': _phone,
      // });
      await Future<void>.delayed(const Duration(milliseconds: 300));
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _saving = false;
      notifyListeners();
    }
  }
}