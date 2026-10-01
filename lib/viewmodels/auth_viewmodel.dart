import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/network/api_exception.dart';
import '../core/utils/validators.dart';
import '../data/repositories/auth_repository.dart';

enum AuthFlow { register, forgotPassword }

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._repo);
  final AuthRepository _repo;

  /// Fired after logout completes (either user-initiated or forced
  /// by the session-expiry handler). Wire this in main.dart to
  /// navigate to LoginScreen.
  void Function()? onLoggedOut;

  // ── Global auth state ───────────────────────────
  bool _isLoggedIn = false;
  bool _isBootstrapping = true;
  bool _hasSeenOnboarding = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isBootstrapping => _isBootstrapping;
  bool get hasSeenOnboarding => _hasSeenOnboarding;

  Future<void> bootstrap() async {
    try {
      _isLoggedIn = await _repo.isLoggedIn();
      _hasSeenOnboarding = await _repo.hasSeenOnboarding();
    } catch (_) {
      _isLoggedIn = false;
      _hasSeenOnboarding = false;
    } finally {
      _isBootstrapping = false;
      notifyListeners();
    }
  }

  Future<void> markOnboardingSeen() async {
    if (_hasSeenOnboarding) return;
    _hasSeenOnboarding = true;
    await _repo.markOnboardingSeen();
    notifyListeners();
  }

  // ── Existing flow state ─────────────────────────
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

  void setFlow(AuthFlow value) {
    if (flow == value) return;
    flow = value;
    notifyListeners();
  }

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

  // ── OTP ─────────────────────────────────────────
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

  // ── Login ───────────────────────────────────────
  Future<bool> login(String email, String password) async {
    final ok = await _run(() => _repo.login(email: email, password: password));
    if (ok) {
      _isLoggedIn = true;
      notifyListeners();
    }
    return ok;
  }

  // ── Logout ──────────────────────────────────────
  /// User-initiated logout. Calls the backend, clears tokens,
  /// resets state, then fires [onLoggedOut] so the app can navigate.
  Future<void> logout() async {
    isLoading = true;
    notifyListeners();
    try {
      await _repo.logout();
    } finally {
      _isLoggedIn = false;
      _resetState();
      notifyListeners();
      onLoggedOut?.call();
    }
  }

  /// Called by ApiClient when the session has expired. Same as
  /// logout() but no backend call.
  void forceLogout() {
    _isLoggedIn = false;
    _resetState();
    notifyListeners();
    onLoggedOut?.call();
  }

  // ── Register / Reset ────────────────────────────
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

  // ── Timer ───────────────────────────────────────
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

  // ── Helpers ─────────────────────────────────────
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
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}