class Validators {
  Validators._();

  static final RegExp _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _phone = RegExp(r'^\+?\d{10,14}$');
  static final RegExp _aadhaar = RegExp(r'^\d{12}$');
  static final RegExp _pincode = RegExp(r'^\d{6}$');
  static final RegExp _uppercase = RegExp(r'[A-Z]');
  static final RegExp _number = RegExp(r'[0-9]');
  static final RegExp _special = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  static bool email(String v) => _email.hasMatch(v.trim());
  static bool phone(String v) => _phone.hasMatch(v.replaceAll(' ', ''));
  static bool aadhaar(String v) => _aadhaar.hasMatch(v);
  static bool pincode(String v) => _pincode.hasMatch(v);

  static bool hasUppercase(String v) => _uppercase.hasMatch(v);
  static bool hasNumber(String v) => _number.hasMatch(v);
  static bool hasSpecial(String v) => _special.hasMatch(v);
  static bool hasMinLength(String v) => v.length >= 8;

  static bool strongPassword(String v) =>
      hasUppercase(v) && hasNumber(v) && hasSpecial(v) && hasMinLength(v);
}