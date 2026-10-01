import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api_exception.dart';
import '../data/models/document_model.dart';
import '../data/repositories/document_repository.dart';

class DocumentViewModel extends ChangeNotifier {
  DocumentViewModel(this._repo);
  final DocumentRepository _repo;

  static const String _idCacheKey = 'document_id_cache_v2';
  static const Duration _cacheTtl = Duration(days: 30);

  bool isLoading = false;
  bool isUploading = false;
  String? errorMessage;
  List<DocumentModel> items = const [];

  // ── ID cache ────────────────────────────────────
  // The backend's GET /documents/ doesn't return ids, but POST does.
  // We store {"<document_type>": {"id": "...", "ts": 1712...}} locally
  // so PATCH reupload works even across app restarts.
  Future<Map<String, String>> _loadIdCache() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_idCacheKey);
    if (raw == null || raw.isEmpty) return {};

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return {};

      final now = DateTime.now().millisecondsSinceEpoch;
      final out = <String, String>{};

      decoded.forEach((k, v) {
        if (v is Map) {
          final id = v['id']?.toString();
          final ts = (v['ts'] as num?)?.toInt() ?? 0;
          if (id != null &&
              id.isNotEmpty &&
              now - ts < _cacheTtl.inMilliseconds) {
            out[k.toString()] = id;
          }
        } else if (v is String && v.isNotEmpty) {
          // Legacy shape — accept it; rewritten on next save.
          out[k.toString()] = v;
        }
      });
      return out;
    } catch (_) {
      return {};
    }
  }

  Future<void> _saveIdCache(Map<String, String> cache) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    final out = <String, Map<String, Object>>{
      for (final e in cache.entries)
        e.key: {'id': e.value, 'ts': now},
    };
    await prefs.setString(_idCacheKey, jsonEncode(out));
  }

  Future<void> _rememberId(String documentType, String id) async {
    if (documentType.isEmpty || id.isEmpty) return;
    final cache = await _loadIdCache();
    cache[documentType] = id;
    await _saveIdCache(cache);
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_idCacheKey);
  }

  /// Fuzzy lookup so `tenth_marks_card` and `10th_marks_card` still hit.
  String? _lookupId(Map<String, String> cache, String type) {
    if (cache.containsKey(type)) return cache[type];
    final needle = _normalize(type);
    if (needle.isEmpty) return null;
    for (final entry in cache.entries) {
      if (_normalize(entry.key) == needle) return entry.value;
    }
    return null;
  }

  String _normalize(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

  // ── GET /documents/ ─────────────────────────────
  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final res = await _repo.list();
      final cache = await _loadIdCache();

      final raw = res.results
          .whereType<Map>()
          .map((e) => DocumentModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      items = raw.map((doc) {
        if (doc.id.isNotEmpty) return doc;
        final cached = _lookupId(cache, doc.documentType) ??
            _lookupId(cache, doc.title);
        if (cached == null || cached.isEmpty) return doc;
        return doc.copyWith(id: cached);
      }).toList();

      if (kDebugMode) {
        for (final d in items) {
          debugPrint(
            '[DOCS] ${d.title} type=${d.documentType} '
            'id=${d.id} status=${d.status}',
          );
        }
      }
    } on ApiException catch (e) {
      errorMessage = e.message;
      // Don't wipe `items` — user still sees the previous list.
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── POST /documents/ ────────────────────────────
  Future<bool> upload({
    required String documentType,
    required File file,
  }) async {
    isUploading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final res = await _repo.upload(
        documentType: documentType,
        file: file,
      );

      // Cache the id from the POST response for later reupload.
      final obj = res.object;
      final data = obj?['data'];
      final map = data is Map ? Map<String, dynamic>.from(data) : obj;
      final id = map?['id']?.toString();
      final returnedType =
          map?['document_type']?.toString() ?? documentType;

      if (id != null && id.isNotEmpty) {
        await _rememberId(documentType, id);
        if (returnedType != documentType) {
          await _rememberId(returnedType, id);
        }
        if (kDebugMode) {
          debugPrint('[DOCS] cached id $id for $documentType');
        }
      }

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

  // ── PATCH /documents/<id>/ ──────────────────────
  Future<bool> reuploadById({
    required String id,
    required File file,
  }) async {
    if (id.isEmpty) {
      errorMessage = 'Document id missing.';
      notifyListeners();
      return false;
    }

    isUploading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repo.reupload(id: id, file: file);
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