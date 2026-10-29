import 'dart:io';

import '../../core/network/api_client.dart';
import '../../core/network/api_response.dart';

class DocumentRepository {
  DocumentRepository(this._api);
  final ApiClient _api;

  // ── GET /documents/ ─────────────────────────────
  Future<ApiResponse> list() async {
    final raw = await _api.get('/documents/');
    return ApiResponse(raw);
  }

  // ── POST /documents/ ────────────────────────────
  //
  // [extraFields] lets callers attach additional form fields on the
  // same multipart request — e.g. Aadhaar uploads send
  // `aadhaar_number` alongside the file.
  Future<ApiResponse> upload({
    required String documentType,
    required File file,
    Map<String, String>? extraFields,
  }) async {
    final raw = await _api.multipart(
      '/documents/',
      method: 'POST',
      fields: {
        'document_type': documentType,
        ...?extraFields,
      },
      files: {'file': file},
    );
    return ApiResponse(raw);
  }

  // ── PATCH /documents/<id>/ ──────────────────────
  Future<ApiResponse> reupload({
    required String id,
    required File file,
  }) async {
    final raw = await _api.multipart(
      '/documents/$id/',
      method: 'PATCH',
      fields: const {},
      files: {'file': file},
    );
    return ApiResponse(raw);
  }
}