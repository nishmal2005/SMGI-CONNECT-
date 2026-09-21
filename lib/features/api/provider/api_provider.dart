import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_models.dart';

class ApiProvider extends ChangeNotifier {
  final ApiClient _client;

  ApiProvider({ApiClient? client}) : _client = client ?? ApiClient();

  bool isLoading = false;
  String? errorMessage;
  ApiResponseModel? response;

  Future<ApiResponseModel> _run(Future<dynamic> Function() operation) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      response = ApiResponseModel.fromJson(await operation());
      return response!;
    } on ApiException catch (error) {
      errorMessage = error.message;
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<ApiResponseModel> _get(String path) =>
      _run(() => _client.request('GET', path));
  Future<ApiResponseModel> _post(
    String path,
    Map<String, dynamic> body, {
    bool authenticated = true,
  }) => _run(
    () =>
        _client.request('POST', path, body: body, authenticated: authenticated),
  );
  Future<ApiResponseModel> _patch(String path, Map<String, dynamic> body) =>
      _run(() => _client.request('PATCH', path, body: body));
  Future<ApiResponseModel> _delete(String path) =>
      _run(() => _client.request('DELETE', path));

  Future<ApiResponseModel> sendOtp(Map<String, dynamic> body) =>
      _post('/send-otp/', body, authenticated: false);
  Future<ApiResponseModel> verifyOtp(Map<String, dynamic> body) =>
      _post('/verify-otp/', body, authenticated: false);
  Future<ApiResponseModel> resendOtp(Map<String, dynamic> body) =>
      _post('/resend-otp/', body, authenticated: false);
  Future<ApiResponseModel> register(Map<String, dynamic> body) =>
      _post('/register/', body, authenticated: false);
  Future<ApiResponseModel> login(Map<String, dynamic> body) =>
      _post('/login/', body, authenticated: false);
  Future<ApiResponseModel> logout(Map<String, dynamic> body) =>
      _post('/logout/', body);
  Future<ApiResponseModel> changePassword(Map<String, dynamic> body) =>
      _post('/change-password/', body);
  Future<ApiResponseModel> passwordReset(Map<String, dynamic> body) =>
      _post('/password-reset/', body, authenticated: false);
  Future<ApiResponseModel> passwordResetConfirm(Map<String, dynamic> body) =>
      _post('/password-reset-confirm/', body, authenticated: false);
  Future<ApiResponseModel> resetPassword(Map<String, dynamic> body) =>
      _post('/reset_password/', body, authenticated: false);

  Future<ApiResponseModel> uploadAadhaar(Map<String, dynamic> body) =>
      _post('/aadhaar/upload/', body);
  Future<ApiResponseModel> updateProfile(Map<String, dynamic> body) =>
      _post('/profile/', body);
  Future<ApiResponseModel> getCourses() => _get('/courses/');
  Future<ApiResponseModel> getCourse(String id) => _get('/courses/$id/');
  Future<ApiResponseModel> createApplication(Map<String, dynamic> body) =>
      _post('/applications/', body);
  Future<ApiResponseModel> getApplicationStatus() =>
      _get('/applications/status/');
  Future<ApiResponseModel> getApplicationReview(String id) =>
      _get('/applications/$id/review/');
  Future<ApiResponseModel> confirmApplicationReview(
    String id,
    Map<String, dynamic> body,
  ) => _post('/applications/$id/review/confirm/', body);
  Future<ApiResponseModel> getPaymentSummary(String id) =>
      _get('/applications/$id/payment-summary/');
  Future<ApiResponseModel> getPaymentSuccess(String id) =>
      _get('/applications/$id/payment-success/');
  Future<ApiResponseModel> getAdmissionAcknowledgment(String id) =>
      _get('/applications/$id/admission-acknowledgment/');
  Future<ApiResponseModel> getDocuments() => _get('/documents/');
  Future<ApiResponseModel> uploadDocument(Map<String, dynamic> body) =>
      _post('/documents/', body);
  Future<ApiResponseModel> getDocument(String id) => _get('/documents/$id/');
  Future<ApiResponseModel> validateReferral(Map<String, dynamic> body) =>
      _post('/referrals/validate/', body);
  Future<ApiResponseModel> applyReferral(Map<String, dynamic> body) =>
      _post('/referrals/apply/', body);
  Future<ApiResponseModel> getReferralHistory() => _get('/referrals/history/');
  Future<ApiResponseModel> getNotifications() => _get('/notifications/');
  Future<ApiResponseModel> getKnowledgeDownloads() =>
      _get('/knowledge-downloads/');
  Future<ApiResponseModel> downloadKnowledgeDocument(String id) =>
      _get('/knowledge-downloads/$id/download/');

  Future<ApiResponseModel> adminLogin(Map<String, dynamic> body) =>
      _post('/admin/auth/login/', body, authenticated: false);
  Future<ApiResponseModel> adminForgotPassword(Map<String, dynamic> body) =>
      _post('/admin/auth/forgot-password/', body, authenticated: false);
  Future<ApiResponseModel> adminVerifyOtp(Map<String, dynamic> body) =>
      _post('/admin/auth/verify-otp/', body, authenticated: false);
  Future<ApiResponseModel> adminResendOtp(Map<String, dynamic> body) =>
      _post('/admin/auth/resend-otp/', body, authenticated: false);
  Future<ApiResponseModel> adminResetPassword(Map<String, dynamic> body) =>
      _post('/admin/auth/reset-password/', body, authenticated: false);
  Future<ApiResponseModel> getAdminDashboard() => _get('/admin/dashboard/');
  Future<ApiResponseModel> getAdminAdmissions() => _get('/admin/admissions/');
  Future<ApiResponseModel> getAdminAdmission(String id) =>
      _get('/admin/admissions/$id/');
  Future<ApiResponseModel> getAdminDocuments() => _get('/admin/documents/');
  Future<ApiResponseModel> getAdminDocument(String id) =>
      _get('/admin/documents/$id/');
  Future<ApiResponseModel> verifyAdminDocument(
    String id,
    Map<String, dynamic> body,
  ) => _patch('/admin/documents/$id/verify/', body);
  Future<ApiResponseModel> rejectAdminDocument(
    String id,
    Map<String, dynamic> body,
  ) => _patch('/admin/documents/$id/reject/', body);
  Future<ApiResponseModel> downloadAdminDocument(String id) =>
      _get('/admin/documents/$id/download/');
  Future<ApiResponseModel> getAdminCourses() => _get('/admin/courses/');
  Future<ApiResponseModel> createAdminCourse(Map<String, dynamic> body) =>
      _post('/admin/courses/', body);
  Future<ApiResponseModel> getAdminDisciplines() =>
      _get('/admin/courses/disciplines/');
  Future<ApiResponseModel> getAdminCourse(String id) =>
      _get('/admin/courses/$id/');
  Future<ApiResponseModel> updateAdminCourse(
    String id,
    Map<String, dynamic> body,
  ) => _patch('/admin/courses/$id/', body);
  Future<ApiResponseModel> getAdminReferrals() => _get('/admin/referrals/');
  Future<ApiResponseModel> createAdminReferral(Map<String, dynamic> body) =>
      _post('/admin/referrals/', body);
  Future<ApiResponseModel> getAdminReferral(String id) =>
      _get('/admin/referrals/$id/');
  Future<ApiResponseModel> activateAdminReferral(String id) =>
      _patch('/admin/referrals/$id/activate/', {});
  Future<ApiResponseModel> disableAdminReferral(String id) =>
      _patch('/admin/referrals/$id/disable/', {});
  Future<ApiResponseModel> getAdminPayments() => _get('/admin/payments/');
  Future<ApiResponseModel> getAdminPayment(String id) =>
      _get('/admin/payments/$id/');
  Future<ApiResponseModel> getNotificationTemplates() =>
      _get('/admin/notifications/templates/');
  Future<ApiResponseModel> getNotificationTemplate(String key) =>
      _get('/admin/notifications/templates/$key/');
  Future<ApiResponseModel> updateNotificationTemplate(
    String key,
    Map<String, dynamic> body,
  ) => _patch('/admin/notifications/templates/$key/', body);
  Future<ApiResponseModel> triggerNotificationTemplate(
    String key,
    Map<String, dynamic> body,
  ) => _post('/admin/notifications/templates/$key/trigger/', body);
  Future<ApiResponseModel> sendManualNotification(Map<String, dynamic> body) =>
      _post('/admin/notifications/manual/', body);
  Future<ApiResponseModel> getAdminKnowledgeDownloads() =>
      _get('/admin/knowledge-downloads/');
  Future<ApiResponseModel> createAdminKnowledgeDownload(
    Map<String, dynamic> body,
  ) => _post('/admin/knowledge-downloads/', body);
  Future<ApiResponseModel> getAdminKnowledgeDownload(String id) =>
      _get('/admin/knowledge-downloads/$id/');
  Future<ApiResponseModel> updateAdminKnowledgeDownload(
    String id,
    Map<String, dynamic> body,
  ) => _patch('/admin/knowledge-downloads/$id/', body);
  Future<ApiResponseModel> downloadAdminKnowledgeDocument(String id) =>
      _get('/admin/knowledge-downloads/$id/download/');
  Future<ApiResponseModel> enableAdminKnowledgeDownload(String id) =>
      _patch('/admin/knowledge-downloads/$id/enable/', {});
  Future<ApiResponseModel> disableAdminKnowledgeDownload(String id) =>
      _patch('/admin/knowledge-downloads/$id/disable/', {});
  Future<ApiResponseModel> getAdminStudents() => _get('/admin/students/');
  Future<ApiResponseModel> getAdminStudent(String id) =>
      _get('/admin/students/$id/');
  Future<ApiResponseModel> updateAdminStudent(
    String id,
    Map<String, dynamic> body,
  ) => _patch('/admin/students/$id/', body);
  Future<ApiResponseModel> resetAdminStudentPassword(
    String id,
    Map<String, dynamic> body,
  ) => _post('/admin/students/$id/reset-password/', body);
  Future<ApiResponseModel> enableAdminStudent(String id) =>
      _patch('/admin/students/$id/enable/', {});
  Future<ApiResponseModel> disableAdminStudent(String id) =>
      _patch('/admin/students/$id/disable/', {});
  Future<ApiResponseModel> getAdmins() => _get('/admin/settings/admins/');
  Future<ApiResponseModel> createAdmin(Map<String, dynamic> body) =>
      _post('/admin/settings/admins/', body);
  Future<ApiResponseModel> getAdmin(String id) =>
      _get('/admin/settings/admins/$id/');
  Future<ApiResponseModel> updateAdmin(String id, Map<String, dynamic> body) =>
      _patch('/admin/settings/admins/$id/', body);
  Future<ApiResponseModel> changeAdminPassword(Map<String, dynamic> body) =>
      _post('/admin/settings/change-password/', body);
  Future<ApiResponseModel> getFeeRules() => _get('/admin/settings/fee-rules/');
  Future<ApiResponseModel> updateFeeRules(Map<String, dynamic> body) =>
      _patch('/admin/settings/fee-rules/', body);
  Future<ApiResponseModel> getAppVersion() =>
      _get('/admin/settings/app-version/');
  Future<ApiResponseModel> getHelpSupport() => _get('/admin/help-support/');
  Future<ApiResponseModel> updateHelpSupport(Map<String, dynamic> body) =>
      _patch('/admin/help-support/', body);
  Future<ApiResponseModel> getFaqs() => _get('/admin/help-support/faqs/');
  Future<ApiResponseModel> createFaq(Map<String, dynamic> body) =>
      _post('/admin/help-support/faqs/', body);
  Future<ApiResponseModel> updateFaq(String id, Map<String, dynamic> body) =>
      _patch('/admin/help-support/faqs/$id/', body);
  Future<ApiResponseModel> deleteFaq(String id) =>
      _delete('/admin/help-support/faqs/$id/');

  Future<ApiResponseModel> uploadMultipart({
    required String path,
    required List<http.MultipartFile> files,
    Map<String, String> fields = const {},
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final preferences = await SharedPreferences.getInstance();
      final request =
          http.MultipartRequest('POST', Uri.parse('${ApiClient.baseUrl}$path'))
            ..fields.addAll(fields)
            ..files.addAll(files);
      final token = preferences.getString('access_token');
      if (token != null) request.headers['Authorization'] = 'Bearer $token';
      final result = await request.send().timeout(ApiClient.timeout);
      final text = await result.stream.bytesToString();
      if (result.statusCode < 200 || result.statusCode >= 300) {
        throw ApiException(
          'Upload failed (${result.statusCode})',
          statusCode: result.statusCode,
        );
      }
      response = ApiResponseModel.fromJson(text.isEmpty ? null : text);
      return response!;
    } on ApiException catch (error) {
      errorMessage = error.message;
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
