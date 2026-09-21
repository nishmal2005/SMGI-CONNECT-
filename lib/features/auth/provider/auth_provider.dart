import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smgi.connect/features/auth/screens/login_screen_main.dart';
import '../services/auth_service.dart';

enum AuthFlow { register, forgotPassword }

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  AuthFlow flow = AuthFlow.register;

  void setFlow(AuthFlow value) {
    flow = value;
    notifyListeners();
  }

  bool isLoading = false;
  String? errorMessage;
  String? verifiedEmail;

  // ================= PASSWORD =================

  String _password = '';
  String _confirmPassword = '';

  void setPassword(String value) {
    _password = value;
    _confirmPassword = '';
    validatePassword(value);
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    if (_confirmPassword == value) return;
    _confirmPassword = value;
    notifyListeners();
  }

  bool get isConfirmPasswordValid =>
      _confirmPassword.isNotEmpty && _password == _confirmPassword;

  bool get canSubmitPassword => isPasswordValid && isConfirmPasswordValid;

  /// OTP TIMER
  int secondsLeft = 0;
  Timer? _timer;

  /// PASSWORD RULES
  bool hasUppercase = false;
  bool hasNumber = false;
  bool hasSpecial = false;
  bool hasMinLength = false;

  // =================SEND OTP =================

  Future<bool> sendOtp(String input) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _service.sendOtp(input);
      startOtpTimer(); // only start timer on success
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> requestPasswordReset(String email) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _service.requestPasswordReset(email);
      startOtpTimer();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resendOtp(String email) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _service.resendOtp(email);
      startOtpTimer();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================= Verify OTP =================

  Future<bool> verifyOtp(String email, String otp) async {
    final success = await _service.verifyOtp(email, otp);

    if (success) {
      verifiedEmail = email;
      notifyListeners();
    }

    return success;
  }

  // ================= OTP Timer =================

  void startOtpTimer() {
    _timer?.cancel();
    secondsLeft = 60;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft > 0) {
        secondsLeft--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  // ================= LOG OUT =================

  Future<void> logout(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      await _service.logout();
    } finally {
      _timer?.cancel();
      secondsLeft = 0;
      verifiedEmail = null;
      _password = '';
      _confirmPassword = '';
      setFlow(AuthFlow.register);
      isLoading = false;
      notifyListeners();

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen2()),
          (route) => false,
        );
      }
    }
  }

  // ================= SET PASSWORD =================

  void validatePassword(String password) {
    hasUppercase = password.contains(RegExp(r'[A-Z]'));
    hasNumber = password.contains(RegExp(r'[0-9]'));
    hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    hasMinLength = password.length >= 8;
    notifyListeners();
  }

  bool get isPasswordValid =>
      hasUppercase && hasNumber && hasSpecial && hasMinLength;

  Future<bool> register({
    required String phone,
    required String fullName,
  }) async {
    if (!canSubmitPassword || verifiedEmail == null) return false;

    try {
      isLoading = true;
      notifyListeners();

      await _service.register(
        email: verifiedEmail!,
        password: _password,
        confirmPassword: _confirmPassword,
      );

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================= LOGIN =================

  Future<bool> login(String input, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final success = await _service.login(input, password);
      return success;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================= RESET PASSWORD =================

  Future<bool> resetPassword() async {
    if (!canSubmitPassword || verifiedEmail == null) return false;

    try {
      isLoading = true;
      notifyListeners();

      return await _service.resetPassword(
        email: verifiedEmail!,
        password: _password,
        confirmPassword: _confirmPassword,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
