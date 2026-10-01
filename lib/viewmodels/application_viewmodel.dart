import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api_exception.dart';
import '../data/repositories/application_repository.dart';

enum AdmissionState { notStarted, inProgress, completed }

class ApplicationViewModel extends ChangeNotifier {
  ApplicationViewModel(this._repo);
  final ApplicationRepository _repo;

  static const _kCompleted = 'admission_completed';
  static const _kAppId     = 'application_id';

  String aadhaarNumber = '';
  String? aadhaarFrontPath;
  String? aadhaarBackPath;

  Map<String, dynamic> personal = const {};

  String? discipline;
  String? program;
  String? courseId;
  String? duration;

  String? marksCardPath;
  String? referralCode;

  bool isSubmitting = false;
  String? errorMessage;
  String? applicationId;

  String? status;
  bool isLoadingStatus = false;
  String? statusError;

  bool _acknowledged = false;

  // ── Public getters ─────────────────────────────
  bool get hasApplication =>
      applicationId != null && applicationId!.isNotEmpty;

  bool get isAdmissionCompleted {
    if (_acknowledged) return true;
    final s = status?.toLowerCase();
    return s == 'approved' ||
        s == 'completed' ||
        s == 'submitted' ||
        s == 'admitted';
  }

  AdmissionState get admissionState {
    if (isAdmissionCompleted) return AdmissionState.completed;
    if (_hasStartedAnyStep)   return AdmissionState.inProgress;
    return AdmissionState.notStarted;
  }

  bool get _hasStartedAnyStep =>
      aadhaarNumber.isNotEmpty ||
      aadhaarFrontPath != null ||
      aadhaarBackPath != null ||
      personal.isNotEmpty ||
      courseId != null ||
      marksCardPath != null ||
      referralCode != null ||
      hasApplication;

  /// Which step "Continue" should open.
  String get resumeStep {
    if (aadhaarFrontPath == null || aadhaarBackPath == null) return 'aadhaar';
    if (personal.isEmpty) return 'personal';
    if (courseId == null) return 'course';
    if (marksCardPath == null) return 'marks';
    if (referralCode == null) return 'referral';
    return 'payment';
  }

  // ── Persistence ─────────────────────────────────
  Future<void> hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    _acknowledged = prefs.getBool(_kCompleted) ?? false;
    applicationId ??= prefs.getString(_kAppId);
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kCompleted, _acknowledged);
    if (applicationId != null) {
      await prefs.setString(_kAppId, applicationId!);
    }
  }

  /// Call from the acknowledgment screen when the last step succeeds.
  Future<void> markCompleted() async {
    _acknowledged = true;
    await _persist();
    notifyListeners();
  }

  // ── Mutators ────────────────────────────────────
  void setAadhaar({
    required String number,
    String? frontPath,
    String? backPath,
  }) {
    aadhaarNumber = number;
    aadhaarFrontPath = frontPath;
    aadhaarBackPath = backPath;
    notifyListeners();
  }

  void setPersonal(Map<String, dynamic> data) {
    personal = data;
    notifyListeners();
  }

  void setCourse({
    required String discipline,
    required String program,
    String? courseId,
    String? duration,
  }) {
    this.discipline = discipline;
    this.program = program;
    this.courseId = courseId;
    this.duration = duration;
    notifyListeners();
  }

  void setMarksCard(String? path) {
    marksCardPath = path;
    notifyListeners();
  }

  void setReferralCode(String? code) {
    referralCode = code;
    notifyListeners();
  }

  // ── Network ─────────────────────────────────────
  Future<bool> submit() async {
    if (courseId == null || courseId!.isEmpty) {
      errorMessage = 'No course selected.';
      notifyListeners();
      return false;
    }
    final courseInt = int.tryParse(courseId!);
    if (courseInt == null) {
      errorMessage = 'Invalid course selected.';
      notifyListeners();
      return false;
    }

    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      final res = await _repo.create({
        'course': courseInt,
        'course_name': program ?? '',
        'aadhaar_number': aadhaarNumber,
        ...personal,
        'referral_code': referralCode,
      });
      final obj = res.object;
      applicationId = obj?['id']?.toString() ??
          obj?['application_id']?.toString();
      await _persist();
      return applicationId != null;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> loadStatus() async {
    if (isLoadingStatus) return;
    isLoadingStatus = true;
    notifyListeners();

    try {
      final res = await _repo.status();
      final obj = res.object;
      status = obj?['status']?.toString() ??
          obj?['application_status']?.toString() ??
          obj?['state']?.toString();

      final id = obj?['id']?.toString() ??
          obj?['application_id']?.toString();
      if (id != null && id.isNotEmpty) applicationId = id;

      final s = status?.toLowerCase();
      if (s == 'approved' || s == 'completed' || s == 'admitted') {
        _acknowledged = true;
      }
      await _persist();
      statusError = null;
    } on ApiException catch (e) {
      if (e.statusCode != 404) statusError = e.message;
    } finally {
      isLoadingStatus = false;
      notifyListeners();
    }
  }

  Future<void> reset() async {
    aadhaarNumber = '';
    aadhaarFrontPath = null;
    aadhaarBackPath = null;
    personal = const {};
    discipline = null;
    program = null;
    courseId = null;
    duration = null;
    marksCardPath = null;
    referralCode = null;
    applicationId = null;
    errorMessage = null;
    status = null;
    statusError = null;
    _acknowledged = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kCompleted);
    await prefs.remove(_kAppId);

    notifyListeners();
  }
}