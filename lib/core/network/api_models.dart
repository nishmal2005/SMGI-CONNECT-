class ApiResponseModel {
  final dynamic data;

  const ApiResponseModel(this.data);

  factory ApiResponseModel.fromJson(dynamic json) => ApiResponseModel(json);

  Map<String, dynamic>? get object =>
      data is Map ? Map<String, dynamic>.from(data as Map) : null;

  List<dynamic> get list =>
      data is List ? List<dynamic>.from(data as List) : [];
}
