import 'package:flutter/foundation.dart';
import 'package:smgi.connect/core/network/api_exception.dart';
import 'package:smgi.connect/data/repositories/application_repository.dart';



class ApplicationViewModel extends ChangeNotifier {
  ApplicationViewModel(this._repo);
  final ApplicationRepository _repo;

  // ── Collected data ──────────────────────────────
  String aadhaarNumber = '';
  String? aadhaarFrontPath;
  String? aadhaarBackPath;

  Map<String, dynamic> personal = const {};

  String? discipline;   // kept for UI display only
  String? program;      // becomes `course_name` in the payload
  String? courseId;     // becomes `course` in the payload

  String? marksCardPath;
  String? referralCode;

  // ── Server state ────────────────────────────────
  bool isSubmitting = false;
  String? errorMessage;
  String? applicationId;

  bool get hasApplication => applicationId != null;

  // ── Setters ─────────────────────────────────────
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
  }) {
    this.discipline = discipline;
    this.program = program;
    this.courseId = courseId;
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

  // ── POST /applications/ ─────────────────────────
  Future<bool> submit() async {
    // Course is required by the backend, and must be a valid int id.
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
        'course': courseInt,             // FK → int id
        'course_name': program ?? '',    // CharField → display name
        'aadhaar_number': aadhaarNumber,
        ...personal,
        'referral_code': referralCode,   // may be null
      });
      final obj = res.object;
      applicationId = obj?['id']?.toString() ??
          obj?['application_id']?.toString();
      return applicationId != null;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  void reset() {
    aadhaarNumber = '';
    aadhaarFrontPath = null;
    aadhaarBackPath = null;
    personal = const {};
    discipline = null;
    program = null;
    courseId = null;
    marksCardPath = null;
    referralCode = null;
    applicationId = null;
    errorMessage = null;
    notifyListeners();
  }
}