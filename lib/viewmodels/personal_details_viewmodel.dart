import 'package:flutter/foundation.dart';

class PersonalDetailsViewModel extends ChangeNotifier {
  // ── Dropdown / date state ────────────────────────
  String _gender = 'Male';
  String? _nationality;
  String? _state;
  String? _district;
  DateTime? _dob;

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

  // ── Aggregate validation ─────────────────────────
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
  }) {
    return name.trim().isNotEmpty &&
        dob.trim().isNotEmpty &&
        father.trim().isNotEmpty &&
        mother.trim().isNotEmpty &&
        phone1.trim().length >= 14 &&
        phone2.trim().length >= 14 &&
        address.trim().isNotEmpty &&
        pincode.trim().length == 6 &&
        _emailRegex.hasMatch(email.trim()) &&
        _nationality != null &&
        _state != null &&
        _district != null;
  }

  static final RegExp _emailRegex =
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  // ── Submit payload ───────────────────────────────
  Map<String, dynamic> buildPayload({
    required String name,
    required String dob,
    required String father,
    required String mother,
    required String phone1,
    required String phone2,
    required String address,
    required String pincode,
    required String email,
  }) {
    return {
      'name': name.trim(),
      'dob': _dob?.toIso8601String() ?? dob.trim(),
      'gender': _gender,
      'father_name': father.trim(),
      'mother_name': mother.trim(),
      'phone1': phone1.trim(),
      'phone2': phone2.trim(),
      'address': address.trim(),
      'postal_code': pincode.trim(),
      'email': email.trim(),
      'nationality': _nationality,
      'state': _state,
      'district': _district,
    };
  }

  void reset() {
    _gender = 'Male';
    _nationality = null;
    _state = null;
    _district = null;
    _dob = null;
    notifyListeners();
  }

  void submit({required String name, required String dob, required String fatherName, required String motherName, required String phone1, required String phone2, required String address, required String pincode, required String email}) {}
}