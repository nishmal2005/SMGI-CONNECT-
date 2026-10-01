class ApiResponse {
  final dynamic data;

  const ApiResponse(this.data);

  Map<String, dynamic>? get object =>
      data is Map ? Map<String, dynamic>.from(data as Map) : null;

  List<dynamic> get list =>
      data is List ? List<dynamic>.from(data as List) : [];

  /// Backend wrappers vary — this tries them all, then falls back
  /// to the raw list. Fixes the "Vault is empty" symptom when the
  /// backend uses a key we didn't expect.
  List<dynamic> get results {
    final o = object;
    if (o == null) return list;

    for (final key in const [
      'results',
      'documents',
      'items',
      'data',
      'student_documents',
      'docs',
      'pending_documents',
      'uploaded_documents',
      'referrals',
      'notifications',
      'payments',
      'history',
      'courses',
    ]) {
      final v = o[key];
      if (v is List) return List<dynamic>.from(v);
    }
    return list;
  }

  bool get isEmpty => data == null;
}