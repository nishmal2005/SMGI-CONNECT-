import 'dart:io';

import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_response.dart';

class DocumentRepository {
  DocumentRepository(this._client);
  final ApiClient _client;

  /// GET /documents/
  Future<ApiResponse> list() async =>
      ApiResponse(await _client.get(ApiEndpoints.documents));

  /// POST /documents/  (multipart)
  ///
  /// Fields:
  ///   document_type — tenth_marks_card | aadhaar_id_proof | other_required
  ///   file          — the actual document
  Future<ApiResponse> upload({
    required String documentType,
    required File file,
  }) async =>
      ApiResponse(await _client.multipart(
        ApiEndpoints.documents,
        fields: {'document_type': documentType},
        files: {'file': file},
      ));

  /// GET /documents/<id>/
  Future<ApiResponse> details(String id) async =>
      ApiResponse(await _client.get(ApiEndpoints.document(id)));

  /// PATCH /documents/<id>/ — replace a rejected document.
  Future<ApiResponse> reupload({
    required String id,
    required File file,
  }) async =>
      ApiResponse(await _client.multipart(
        ApiEndpoints.document(id),
        fields: const {},
        files: {'file': file},
        method: 'PATCH',
      ));
}