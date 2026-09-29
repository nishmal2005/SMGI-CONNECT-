/// Single source of truth for every backend path.
/// Base URL: https://sweat-refueling-trustee.ngrok-free.dev/api
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl =
      'https://sweat-refueling-trustee.ngrok-free.dev/api';

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

  // ── Profile & Aadhaar ────────────────────────────
  static const String profile = '/profile/'; // GET, POST, PATCH
  static const String aadhaarUpload = '/aadhaar/upload/';

  // ── Courses ──────────────────────────────────────
  static const String courses = '/courses/';
  static String course(String id) => '/courses/$id/';

  // ── Applications ─────────────────────────────────
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

  // ── Documents ────────────────────────────────────
  static const String documents = '/documents/';
  static String document(String id) => '/documents/$id/'; // GET, PATCH

  // ── Referrals ────────────────────────────────────
  static const String referralValidate = '/referrals/validate/';
  static const String referralApply = '/referrals/apply/';
  static const String referralHistory = '/referrals/history/';

  // ── Notifications ────────────────────────────────
  static const String notifications = '/notifications/';

  // ── Payments (student) ───────────────────────────
  /// GET — the authenticated student's payment history.
  static const String paymentsHistory = '/payments/history/';

  // ── Knowledge downloads ──────────────────────────
  static const String knowledgeDownloads = '/knowledge-downloads/';
  static String knowledgeDownload(String id) =>
      '/knowledge-downloads/$id/download/';

  // ── Help & Support ───────────────────────────────
  static const String helpSupport = '/help-support/';

  // ── Diagnostics ──────────────────────────────────
  /// GET — verify the JWT is still valid.
  static const String authTest = '/auth-test/';
}
