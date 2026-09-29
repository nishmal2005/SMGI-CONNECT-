class ApiResponse {
  final dynamic data;

  const ApiResponse(this.data);

  Map<String, dynamic>? get object =>
      data is Map ? Map<String, dynamic>.from(data as Map) : null;

  List<dynamic> get list =>
      data is List ? List<dynamic>.from(data as List) : [];

  /// Backend often wraps list responses in {results: [...]}.
  List<dynamic> get results {
    final o = object;
    if (o != null && o['results'] is List) {
      return List<dynamic>.from(o['results'] as List);
    }
    return list;
  }

  bool get isEmpty => data == null;
}