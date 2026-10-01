class ReferralModel {
  final String referralCode;
  final String status;

  /// Human-readable course string, e.g. "Engineering · B.Tech · 4 years".
  /// Built from a string OR a nested object from the backend.
  final String course;

  final String referrerName;
  final String referrerId;
  final String referrerMobile;
  final String referrerState;

  const ReferralModel({
    required this.referralCode,
    required this.status,
    required this.course,
    required this.referrerName,
    required this.referrerId,
    required this.referrerMobile,
    required this.referrerState,
  });

  bool get hasReferrer =>
      referrerName.isNotEmpty || referrerMobile.isNotEmpty;

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    // Unwrap `data: { ... }` if the backend wraps the payload.
    final root = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;

    return ReferralModel(
      referralCode: _first([
        root['referral_code'],
        root['code'],
        json['referral_code'],
      ]),
      status: _first([
        root['status'],
        root['state'],
      ], fallback: 'Applied'),
      course: _courseString(root['course'] ?? root['course_name']),
      referrerName: _first([
        root['referrer_name'],
        root['referrerName'],
        root['name'],
        root['mediator_name'],
        root['referred_by'],
      ]),
      referrerId: _first([
        root['referrer_id'],
        root['referrerId'],
        root['referrer_code'],
        root['mediator_id'],
        root['id'],
      ]),
      referrerMobile: _first([
        root['referrer_mobile'],
        root['referrerMobile'],
        root['mobile'],
        root['phone'],
        root['contact'],
      ]),
      referrerState: _first([
        root['referrer_state'],
        root['referrerState'],
        root['state'],
      ]),
    );
  }

  // ── Helpers ─────────────────────────────────────
  static String _first(List<dynamic> values, {String fallback = ''}) {
    for (final v in values) {
      if (v == null) continue;
      final s = v.toString().trim();
      if (s.isNotEmpty) return s;
    }
    return fallback;
  }

  /// Course may arrive as a string, or as a nested object:
  ///   { "id": 8, "discipline": "Engineering", "program": "B.Tech", "duration": 4 }
  /// → "Engineering · B.Tech · 4 years"
  static String _courseString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value.trim();
    if (value is Map) {
      final m = Map<String, dynamic>.from(value);
      final discipline = m['discipline']?.toString().trim() ?? '';
      final program = m['program']?.toString().trim() ??
          m['name']?.toString().trim() ??
          m['title']?.toString().trim() ??
          '';
      final duration = m['duration']?.toString().trim() ?? '';

      final parts = <String>[
        if (discipline.isNotEmpty) discipline,
        if (program.isNotEmpty) program,
        if (duration.isNotEmpty) '$duration years',
      ];
      return parts.join(' · ');
    }
    return value.toString();
  }
}