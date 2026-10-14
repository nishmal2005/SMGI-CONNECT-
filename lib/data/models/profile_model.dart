/// Parsed backend profile.
class ProfileModel {
  final String name;
  final String email;
  final String? avatar;

  final String? motherName;
  final String? contact1;
  final String? contact2;
  final String? address;
  final String? postalCode;
  final String? nationality;
  final String? state;
  final String? district;

  final CourseInfo? course;

  const ProfileModel({
    required this.name,
    required this.email,
    this.avatar,
    this.motherName,
    this.contact1,
    this.contact2,
    this.address,
    this.postalCode,
    this.nationality,
    this.state,
    this.district,
    this.course,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    // Unwrap { data: {...} } if the backend wraps it.
    final root = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;

    return ProfileModel(
      name: root['name']?.toString() ?? '',
      email: root['email']?.toString() ?? '',
      avatar: root['avatar']?.toString() ??
          root['image']?.toString() ??
          root['profile_image']?.toString(),
      motherName: root['mother_name']?.toString(),
      contact1: root['contact_1']?.toString(),
      contact2: root['contact_2']?.toString(),
      address: root['address']?.toString(),
      postalCode: root['postal_code']?.toString(),
      nationality: root['nationality']?.toString(),
      state: root['state']?.toString(),
      district: root['district']?.toString(),
      course: _parseCourse(root['course']),
    );
  }

  static CourseInfo? _parseCourse(dynamic raw) {
    if (raw == null) return null;
    if (raw is String) {
      // Backend sometimes sends a plain string like "Mtech".
      if (raw.trim().isEmpty) return null;
      return CourseInfo(discipline: '', programName: raw.trim());
    }
    if (raw is Map) {
      return CourseInfo.fromJson(Map<String, dynamic>.from(raw));
    }
    return null;
  }

  /// Display-ready course label: "discipline · program"
  String get courseLabel {
    if (course == null || course!.isEmpty) return '—';
    return course!.display;
  }
}

/// The nested `course` object from the backend.
class CourseInfo {
  final String discipline;
  final String programName;

  const CourseInfo({
    required this.discipline,
    required this.programName,
  });

  factory CourseInfo.fromJson(Map<String, dynamic> json) => CourseInfo(
        discipline: json['discipline']?.toString() ?? '',
        programName: json['program_name']?.toString() ??
            json['program']?.toString() ??
            json['course_name']?.toString() ??
            '',
      );

  bool get isEmpty => discipline.isEmpty && programName.isEmpty;

  /// Discipline first, then program name.
  String get display {
    if (discipline.isEmpty && programName.isEmpty) return '—';
    if (discipline.isEmpty) return programName;
    if (programName.isEmpty) return discipline;
    return '$discipline · $programName';
  }
}