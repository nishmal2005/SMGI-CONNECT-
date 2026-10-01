import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../viewmodels/application_viewmodel.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/gap.dart';

class ApplicationStatusScreen extends StatefulWidget {
  const ApplicationStatusScreen({super.key});

  @override
  State<ApplicationStatusScreen> createState() =>
      _ApplicationStatusScreenState();
}

class _ApplicationStatusScreenState extends State<ApplicationStatusScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ApplicationViewModel>().loadStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ApplicationViewModel>();

    return AppScaffold(
      body: Column(
        children: [
          const HomeAppBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => vm.loadStatus(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Application Status',
                        style: AppTextStyles.pageTitle),
                    const Gap(h: 20),
                    _statusBanner(vm),
                    const Gap(h: 24),
                    _detailCard(vm),
                    const Gap(h: 24),
                    _stepsChecklist(vm),
                    const Gap(h: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBanner(ApplicationViewModel vm) {
    final (text, color, icon) = _describe(vm.status);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32.r),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: AppTextStyles.body2.copyWith(
                    fontSize: 16.sp,
                    color: color,
                  ),
                ),
                const Gap(h: 4),
                Text(
                  vm.isAdmissionCompleted
                      ? 'Your admission process is complete.'
                      : 'We are processing your application.',
                  style: AppTextStyles.body3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailCard(ApplicationViewModel vm) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Application Details',
              style: AppTextStyles.body2.copyWith(fontSize: 15.sp)),
          const Gap(h: 12),
          _row('Application ID', vm.applicationId ?? '—'),
          _row('Course', vm.program ?? '—'),
          _row('Discipline', vm.discipline ?? '—'),
          _row('Status', vm.status ?? '—'),
        ],
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120.w,
              child: Text(label, style: AppTextStyles.body3),
            ),
            Expanded(
              child: Text(
                value,
                style: AppTextStyles.body2.copyWith(fontSize: 13.sp),
              ),
            ),
          ],
        ),
      );

  Widget _stepsChecklist(ApplicationViewModel vm) {
    final steps = <(String, bool)>[
      ('Aadhaar Verification',
          vm.aadhaarFrontPath != null && vm.aadhaarBackPath != null),
      ('Personal Details', vm.personal.isNotEmpty),
      ('Course Selection', vm.courseId != null),
      ('10th Marks Card', vm.marksCardPath != null),
      ('Referral', vm.referralCode != null),
      ('Application Submitted', vm.hasApplication),
      ('Admission Completed', vm.isAdmissionCompleted),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Progress',
              style: AppTextStyles.body2.copyWith(fontSize: 15.sp)),
          const Gap(h: 12),
          ...steps.map(
            (s) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  Icon(
                    s.$2
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    size: 20.r,
                    color: s.$2 ? AppColors.success : AppColors.gray,
                  ),
                  SizedBox(width: 10.w),
                  Text(s.$1,
                      style:
                          AppTextStyles.body2.copyWith(fontSize: 13.sp)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  (String, Color, IconData) _describe(String? s) {
    switch (s?.toLowerCase()) {
      case 'approved':
      case 'completed':
      case 'admitted':
        return ('Approved', AppColors.success, Icons.verified);
      case 'submitted':
        return ('Submitted', AppColors.primary, Icons.assignment_turned_in);
      case 'pending':
      case 'in_review':
      case 'under_review':
        return ('Under Review', AppColors.warning, Icons.hourglass_top);
      case 'rejected':
        return ('Rejected', AppColors.error, Icons.cancel);
      default:
        return ('Not Started', AppColors.gray, Icons.info_outline);
    }
  }
}