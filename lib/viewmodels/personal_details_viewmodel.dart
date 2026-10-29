import 'package:flutter/foundation.dart';

import '../core/network/api_exception.dart';
import '../data/repositories/profile_repository.dart';

class PersonalDetailsViewModel extends ChangeNotifier {
  PersonalDetailsViewModel(this._repo);
  final ProfileRepository _repo;

  // ── Dropdown / date state ────────────────────────
  String _gender = 'Male';
  String? _nationality;
  String? _state;
  String? _district;
  DateTime? _dob;

  // ── Server state ─────────────────────────────────
  bool saving = false;
  String? errorMessage;

  String get gender => _gender;
  String? get nationality => _nationality;
  String? get state => _state;
  String? get district => _district;
  DateTime? get dob => _dob;

  String get dobFormatted {
    final d = _dob;
    if (d == null) return '';
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }

  void setGender(String v) {
    if (_gender == v) return;
    _gender = v;
    notifyListeners();
  }

  void setNationality(String? v) {
    if (_nationality == v) return;
    _nationality = v;
    notifyListeners();
  }

  void setState(String? v) {
    if (_state == v) return;
    _state = v;
    notifyListeners();
  }

  void setDistrict(String? v) {
    if (_district == v) return;
    _district = v;
    notifyListeners();
  }

  void setDob(DateTime v) {
    _dob = v;
    notifyListeners();
  }

  /// Validates the form using the **effective** state/district values.
  /// For Indian users these come from the dropdowns (`vm.state` /
  /// `vm.district`); for non-Indian users they come from the free-text
  /// fields on the screen. Either way the caller passes them in.
  bool canContinue({
    required String name,
    required String dob,
    required String father,
    required String mother,
    required String phone1,
    required String phone2,
    required String address,
    required String pincode,
    required String email,
    required String state,
    required String district,
  }) {
    final d1 = _digitsOnly(phone1);
    final d2 = _digitsOnly(phone2);

    return name.trim().isNotEmpty &&
        dob.trim().isNotEmpty &&
        father.trim().isNotEmpty &&
        mother.trim().isNotEmpty &&
        d1.length >= 10 &&
        d1.length <= 15 &&
        (d2.isEmpty || (d2.length >= 10 && d2.length <= 15)) &&
        address.trim().isNotEmpty &&
        pincode.trim().length == 6 &&
        _emailRegex.hasMatch(email.trim()) &&
        _nationality != null &&
        state.trim().isNotEmpty &&
        district.trim().isNotEmpty;
  }

  static final RegExp _emailRegex =
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  Future<bool> submit({
    required String name,
    required String dob,
    required String father,
    required String mother,
    required String phone1,
    required String phone2,
    required String address,
    required String pincode,
    required String email,
    // NEW: effective state / district / nationality passed in by the
    // screen, so non-Indian users' free-text values reach the backend.
    required String state,
    required String district,
    required String nationality,
  }) async {
    saving = true;
    errorMessage = null;
    notifyListeners();

    try {
      final isoDob = _dob != null
          ? _dob!.toIso8601String().split('T').first
          : _normalizeDob(dob);

      final c1 = _digitsOnly(phone1);
      final c2 = _digitsOnly(phone2);

      final body = <String, dynamic>{
        'full_name': name.trim(),
        'dob': isoDob,
        'gender': _normalizeGender(_gender),
        'father_name': father.trim(),
        'mother_name': mother.trim(),
        'contact_1': c1,
        'contact_2': c2.length >= 10 ? c2 : null,
        'address': address.trim(),
        'postal_code': pincode.trim(),
        'email': email.trim(),
        'nationality': nationality,
        'state': state.trim(),
        'district': district.trim(),
      };

      await _repo.save(body);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } finally {
      saving = false;
      notifyListeners();
    }
  }

  /// Maps any UI-originated gender string to the exact value the backend
  /// expects: 'Male' | 'Female' | 'Other' | 'Prefer not to say'.
  String _normalizeGender(String? raw) {
    final t = (raw ?? '').trim().toLowerCase();
    switch (t) {
      case 'male':
      case 'm':
        return 'Male';
      case 'female':
      case 'f':
        return 'Female';
      case 'other':
      case 'o':
        return 'Other';
      case 'prefer not to say':
      case 'prefer_not_to_say':
      case 'prefernottosay':
        return 'Prefer not to say';
      default:
        // Unknown value — default to Male rather than sending garbage.
        return 'Male';
    }
  }

  String _digitsOnly(String raw) => raw.replaceAll(RegExp(r'\D'), '');

  String _normalizeDob(String raw) {
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(raw)) return raw;
    final parts = raw.split('/');
    if (parts.length == 3) {
      final d = parts[0].padLeft(2, '0');
      final m = parts[1].padLeft(2, '0');
      final y = parts[2];
      return '$y-$m-$d';
    }
    return raw;
  }

  void reset() {
    _gender = 'Male';
    _nationality = null;
    _state = null;
    _district = null;
    _dob = null;
    errorMessage = null;
    saving = false;
    notifyListeners();
  }
}