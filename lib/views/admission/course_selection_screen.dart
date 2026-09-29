import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/data/models/course_model.dart';
import 'package:smgi.connect/viewmodels/application_viewmodel.dart';
import 'package:smgi.connect/viewmodels/course_viewmodel.dart';


import '../../widgets/app_scaffold.dart';
import '../../widgets/gap.dart';
import 'upload_marks_card_screen.dart';

class CourseSelectionScreen extends StatefulWidget {
  const CourseSelectionScreen({super.key});

  @override
  State<CourseSelectionScreen> createState() =>
      _CourseSelectionScreenState();
}

class _CourseSelectionScreenState extends State<CourseSelectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseViewModel>().load();
    });
  }

  void _onContinue() {
    final vm = context.read<CourseViewModel>();

    debugPrint(
      'COURSE SELECTED: id=${vm.selectedProgramId} '
      'discipline=${vm.selectedDisciplineTitle} '
      'program=${vm.selectedProgramTitle}',
    );

    if (!vm.hasSelection ||
        vm.selectedProgramId == null ||
        vm.selectedProgramId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a course.')),
      );
      return;
    }

    context.read<ApplicationViewModel>().setCourse(
          discipline: vm.selectedDisciplineTitle ?? '',
          program: vm.selectedProgramTitle ?? '',
          courseId: vm.selectedProgramId,
        );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UploadMarksCardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CourseViewModel>();

    return AppScaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 8.h,
              ),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.accent,
                  size: 20.r,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Course Selection',
                style: AppTextStyles.pageTitle,
              ),
            ),

            const Gap(h: 16),

            Expanded(child: _buildBody(vm)),

            Padding(
              padding: EdgeInsets.all(16.w),
              child: GestureDetector(
                onTap: vm.hasSelection ? _onContinue : null,
                child: Opacity(
                  opacity: vm.hasSelection ? 1.0 : 0.5,
                  child: Container(
                    width: double.infinity,
                    height: 52.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26.r),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF0A1E4D),
                          Color(0xFF15347A),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 18.r,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(CourseViewModel vm) {
    if (vm.isLoading && vm.disciplines.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.errorMessage != null && vm.disciplines.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                vm.errorMessage!,
                textAlign: TextAlign.center,
                style: AppTextStyles.body2.copyWith(color: AppColors.error),
              ),
              Gap(h: 12),
              TextButton(
                onPressed: vm.load,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    if (vm.disciplines.isEmpty) {
      return Center(
        child: Text(
          'No courses available.',
          style: AppTextStyles.body2.copyWith(color: AppColors.gray),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      itemCount: vm.disciplines.length,
      itemBuilder: (_, i) {
        final d = vm.disciplines[i];
        final expanded = vm.expandedDisciplineId == d.id;

        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: _DisciplineTile(
            discipline: d,
            expanded: expanded,
            selectedProgramId: vm.selectedProgramId,
            onToggle: () => vm.toggleDiscipline(d.id),
            onSelect: (program) => vm.selectProgram(
              disciplineTitle: d.title,
              program: program,
            ),
          ),
        );
      },
    );
  }
}

class _DisciplineTile extends StatelessWidget {
  final CourseModel discipline;
  final bool expanded;
  final String? selectedProgramId;
  final VoidCallback onToggle;
  final ValueChanged<ProgramModel> onSelect;

  const _DisciplineTile({
    required this.discipline,
    required this.expanded,
    required this.selectedProgramId,
    required this.onToggle,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final visuals = _iconFor(discipline.title);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE7E7E7)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12.r),
              bottom: Radius.circular(expanded ? 0 : 12.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 14.h,
              ),
              child: Row(
                children: [
                  Icon(visuals.icon, color: visuals.color, size: 20.r),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      discipline.title,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.gray,
                    size: 22.r,
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12.r),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Column(
                children: discipline.programs.map((p) {
                  final selected = p.id == selectedProgramId;
                  return InkWell(
                    onTap: () => onSelect(p),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              p.title,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          _Radio(selected: selected),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  ({IconData icon, Color color}) _iconFor(String title) {
    final t = title.toLowerCase();
    if (t.contains('nurs')) {
      return (icon: Icons.favorite, color: const Color(0xFF2FAE60));
    }
    if (t.contains('paramed')) {
      return (
        icon: Icons.medical_services,
        color: const Color(0xFF1E9E8C),
      );
    }
    if (t.contains('pharm')) {
      return (icon: Icons.medication, color: const Color(0xFFF5A623));
    }
    if (t.contains('ahs') || t.contains('allied')) {
      return (
        icon: Icons.medical_information,
        color: const Color(0xFF7B4FE0),
      );
    }
    if (t.contains('physio')) {
      return (
        icon: Icons.accessibility_new,
        color: const Color(0xFF1E9E8C),
      );
    }
    if (t.contains('law')) {
      return (icon: Icons.gavel, color: const Color(0xFFE0405C));
    }
    return (icon: Icons.school, color: AppColors.primary);
  }
}

class _Radio extends StatelessWidget {
  final bool selected;
  const _Radio({required this.selected});

  @override
  Widget build(BuildContext context) {
    final size = 18.r;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primary : const Color(0xFF9BA3B0),
          width: 1.5.w,
        ),
      ),
      alignment: Alignment.center,
      child: selected
          ? Container(
              width: size * 0.5,
              height: size * 0.5,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
            )
          : null,
    );
  }
}