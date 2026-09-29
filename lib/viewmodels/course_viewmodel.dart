import 'package:flutter/foundation.dart';
import 'package:smgi.connect/core/network/api_exception.dart';
import 'package:smgi.connect/data/models/course_model.dart';
import 'package:smgi.connect/data/repositories/course_repository.dart';



class CourseViewModel extends ChangeNotifier {
  CourseViewModel(this._repo);
  final CourseRepository _repo;

  bool isLoading = false;
  String? errorMessage;

  /// Grouped list — one entry per discipline, each carrying its programs.
  /// Populated by [load] which handles both the grouped and flat
  /// backend response shapes.
  List<CourseModel> disciplines = const [];

  /// Which discipline tile is expanded. Null = all collapsed.
  String? expandedDisciplineId;

  /// Currently selected program (radio).
  String? selectedProgramId;
  String? selectedDisciplineTitle;
  String? selectedProgramTitle;

  bool get hasSelection => selectedProgramId != null;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final res = await _repo.list();
      final raw = res.results.whereType<Map>().toList();
      disciplines = _group(raw);
    } on ApiException catch (e) {
      errorMessage = e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Accepts both shapes:
  ///  - grouped: `[{id, discipline, programs: [...]}, ...]`
  ///  - flat:    `[{id, discipline, program}, ...]`
  List<CourseModel> _group(List<Map> raw) {
    if (raw.isEmpty) return const [];

    // Detect grouped shape.
    final hasNested = raw.any(
      (e) => e['programs'] is List && (e['programs'] as List).isNotEmpty,
    );

    if (hasNested) {
      // Grouped — parse directly.
      return raw
          .map((e) => CourseModel.fromJson(Map<String, dynamic>.from(e)))
          .where((c) => c.programs.isNotEmpty)
          .toList();
    }

    // Flat — group by discipline string.
    final buckets = <String, List<ProgramModel>>{};
    final titles = <String, String>{};

    for (final item in raw) {
      final discipline = (item['discipline']?.toString().trim().isNotEmpty ??
              false)
          ? item['discipline'].toString().trim()
          : 'Others';
      final program = ProgramModel.fromJson(
        Map<String, dynamic>.from(item),
      );
      if (program.id.isEmpty) continue; // skip bad rows

      final key = discipline.toLowerCase();
      buckets.putIfAbsent(key, () => []).add(program);
      titles.putIfAbsent(key, () => discipline);
    }

    return buckets.entries.map((e) {
      final programs = e.value;
      return CourseModel(
        id: e.key,
        title: titles[e.key] ?? e.key,
        programs: programs,
      );
    }).toList();
  }

  // ── Interactions ─────────────────────────────────
  void toggleDiscipline(String disciplineId) {
    expandedDisciplineId =
        expandedDisciplineId == disciplineId ? null : disciplineId;
    notifyListeners();
  }

  void selectProgram({
    required String disciplineTitle,
    required ProgramModel program,
  }) {
    selectedProgramId = program.id;
    selectedDisciplineTitle = disciplineTitle;
    selectedProgramTitle = program.title;
    notifyListeners();
  }

  void clearSelection() {
    selectedProgramId = null;
    selectedDisciplineTitle = null;
    selectedProgramTitle = null;
    notifyListeners();
  }

  void reset() {
    disciplines = const [];
    expandedDisciplineId = null;
    clearSelection();
    errorMessage = null;
    isLoading = false;
    notifyListeners();
  }
}