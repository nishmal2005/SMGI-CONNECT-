class ApiEndpoints {
  ApiEndpoints._();

  
  static const String baseUrl =
      'https://sweat-refueling-trustee.ngrok-free.dev/api';

  /// Fail-fast check for the base URL. Call once from main().
  static void validate() {
    assert(
      baseUrl.startsWith('http://') || baseUrl.startsWith('https://'),
      'ApiEndpoints.baseUrl must start with http:// or https:// — got: $baseUrl',
    );
    assert(
      !baseUrl.endsWith('/'),
      'ApiEndpoints.baseUrl must not end with / — got: $baseUrl',
    );
  }

  // ── Student auth ─────────────────────────────────
  static const String sendOtp = '/send-otp/';
  static const String verifyOtp = '/verify-otp/';
  static const String resendOtp = '/resend-otp/';
  static const String register = '/register/';
  static const String login = '/login/';
  static const String logout = '/logout/';
  static const String changePassword = '/change-password/';
  static const String passwordReset = '/password-reset/';
  static const String passwordResetConfirm = '/password-reset-confirm/';
  static const String resetPassword = '/reset_password/';

  static const String tokenRefresh = '/token/refresh/';

  static const String profile = '/profile/';
  static const String aadhaarUpload = '/aadhaar/upload/';
  static const String aadhaarReupload = '/aadhaar/';

  static const String courses = '/courses/';
  static String course(String id) => '/courses/$id/';

  static const String createApplication = '/applications/';
  static const String applicationStatus = '/applications/status/';
  static String applicationReview(String id) => '/applications/$id/review/';
  static String applicationReviewConfirm(String id) =>
      '/applications/$id/review/confirm/';
  static String applicationPaymentSummary(String id) =>
      '/applications/$id/payment-summary/';
  static String applicationPaymentSuccess(String id) =>
      '/applications/$id/payment-success/';
  static String applicationAcknowledgment(String id) =>
      '/applications/$id/admission-acknowledgment/';

  static const String documents = '/documents/';
  static String document(String id) => '/documents/$id/';

  static const String referralValidate = '/referrals/validate/';
  static const String referralApply = '/referrals/apply/';
  static const String referralHistory = '/referrals/history/';

  static const String notifications = '/notifications/';
  static const String paymentsHistory = '/payments/history/';

  static const String knowledgeDownloads = '/knowledge-downloads/';
  static String knowledgeDownload(String id) =>
      '/knowledge-downloads/$id/download/';

  static const String helpSupport = '/help-support/';
  static const String authTest = '/auth-test/';
}