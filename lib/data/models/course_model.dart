class CourseModel {
  /// Discipline id (the group).
  final String id;
  final String title;              
  final String? description;

  /// Programs under this discipline. Empty for the flat shape —
  /// in that case the discipline is one and the program is [title].
  final List<ProgramModel> programs;

  const CourseModel({
    required this.id,
    required this.title,
    this.description,
    this.programs = const [],
  });

  /// True when this course is a program in the flat layout
  /// (i.e. has no nested programs).
  bool get isProgram => programs.isEmpty;

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final rawPrograms = json['programs'];
    final programs = rawPrograms is List
        ? rawPrograms
            .whereType<Map>()
            .map((p) => ProgramModel.fromJson(Map<String, dynamic>.from(p)))
            .toList()
        : const <ProgramModel>[];

    return CourseModel(
      id: json['id']?.toString() ?? '',
      title: json['discipline']?.toString() ??
          json['title']?.toString() ??
          json['name']?.toString() ??
          '',
      description: json['description']?.toString(),
      programs: programs,
    );
  }
}

class ProgramModel {
  final String id;
  final String title;
  final String? discipline;       // filled by the VM for the flat case

  const ProgramModel({
    required this.id,
    required this.title,
    this.discipline,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) => ProgramModel(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ??
            json['name']?.toString() ??
            json['program']?.toString() ??
            '',
        discipline: json['discipline']?.toString(),
      );
}