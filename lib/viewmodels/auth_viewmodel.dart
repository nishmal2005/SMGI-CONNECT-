import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:smgi.connect/core/network/api_exception.dart';
import 'package:smgi.connect/core/utils/validators.dart';
import 'package:smgi.connect/data/repositories/auth_repository.dart';



enum AuthFlow { register, forgotPassword }

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._repo);
  final AuthRepository _repo;

  AuthFlow flow = AuthFlow.register;
  bool isLoading = false;
  String? errorMessage;
  String? verifiedEmail;

  String _password = '';
  String _confirmPassword = '';

  int secondsLeft = 0;
  Timer? _timer;

  bool hasUppercase = false;
  bool hasNumber = false;
  bool hasSpecial = false;
  bool hasMinLength = false;

  // ── Flow ─────────────────────────────────────────
  void setFlow(AuthFlow value) {
    if (flow == value) return;
    flow = value;
    notifyListeners();
  }

  // ── Password ─────────────────────────────────────
  void setPassword(String value) {
    _password = value;
    hasUppercase = Validators.hasUppercase(value);
    hasNumber = Validators.hasNumber(value);
    hasSpecial = Validators.hasSpecial(value);
    hasMinLength = Validators.hasMinLength(value);
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  /// Wipes the password fields and the four rule booleans.
  /// Call after a successful register / reset so the next user
  /// sees a fresh, unchecked password screen.
  void clearPasswords() {
    _password = '';
    _confirmPassword = '';
    hasUppercase = false;
    hasNumber = false;
    hasSpecial = false;
    hasMinLength = false;
    notifyListeners();
  }

  bool get isPasswordValid =>
      hasUppercase && hasNumber && hasSpecial && hasMinLength;

  bool get isConfirmPasswordValid =>
      _confirmPassword.isNotEmpty && _password == _confirmPassword;

  bool get canSubmitPassword => isPasswordValid && isConfirmPasswordValid;

  // ── OTP ──────────────────────────────────────────
  Future<bool> sendOtp(String email) =>
      _run(() => _repo.sendOtp(email), startTimer: true);

  Future<bool> resendOtp(String email) =>
      _run(() => _repo.resendOtp(email), startTimer: true);

  Future<bool> requestPasswordReset(String email) =>
      _run(() => _repo.passwordReset(email), startTimer: true);

  Future<bool> verifyOtp(String email, String otp) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _repo.verifyOtp(email, otp);
      verifiedEmail = email;
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Register / Login / Reset ─────────────────────
  Future<bool> register() async {
    if (!canSubmitPassword || verifiedEmail == null) return false;
    return _run(() => _repo.register(
          email: verifiedEmail!,
          password: _password,
          confirmPassword: _confirmPassword,
        ));
  }

  Future<bool> resetPassword() async {
    if (!canSubmitPassword || verifiedEmail == null) return false;
    return _run(() => _repo.resetPassword(
          email: verifiedEmail!,
          password: _password,
          confirmPassword: _confirmPassword,
        ));
  }

  Future<bool> login(String email, String password) =>
      _run(() => _repo.login(email: email, password: password));

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();
    try {
      await _repo.logout();
    } finally {
      _resetState();
    }
  }

  // ── Timer ────────────────────────────────────────
  void startOtpTimer() {
    _timer?.cancel();
    secondsLeft = 60;
    notifyListeners();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft > 0) {
        secondsLeft--;
        notifyListeners();
      } else {
        t.cancel();
      }
    });
  }

  // ── Helpers ──────────────────────────────────────
  Future<bool> _run(
    Future<dynamic> Function() op, {
    bool startTimer = false,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await op();
      if (startTimer) startOtpTimer();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _resetState() {
    _timer?.cancel();
    secondsLeft = 0;
    verifiedEmail = null;
    _password = '';
    _confirmPassword = '';
    hasUppercase = false;
    hasNumber = false;
    hasSpecial = false;
    hasMinLength = false;
    flow = AuthFlow.register;
    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}