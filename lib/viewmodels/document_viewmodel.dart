import 'dart:io';

import 'package:flutter/foundation.dart';

import '../core/network/api_exception.dart';
import '../data/models/document_model.dart';
import '../data/repositories/document_repository.dart';

class DocumentViewModel extends ChangeNotifier {
  DocumentViewModel(this._repo);
  final DocumentRepository _repo;

  bool isLoading = false;
  bool isUploading = false;
  String? errorMessage;
  List<DocumentModel> items = const [];

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final res = await _repo.list();
      items = res.results
          .whereType<Map>()
          .map((e) => DocumentModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on ApiException catch (e) {
      errorMessage = e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// POST /documents/
  ///
  /// [documentType] — e.g. tenth_marks_card
  Future<bool> upload({
    required String documentType,
    required File file,
  }) async {
    isUploading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repo.upload(documentType: documentType, file: file);
      await load();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  /// PATCH /documents/<id>/
  ///
  /// Re-upload a rejected or reupload-required document.
  Future<bool> reupload({
    required DocumentModel doc,
    required File file,
  }) async {
    if (doc.id.isEmpty) {
      errorMessage = 'Document id missing — cannot re-upload.';
      notifyListeners();
      return false;
    }

    isUploading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repo.reupload(id: doc.id, file: file);
      await load();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }
}