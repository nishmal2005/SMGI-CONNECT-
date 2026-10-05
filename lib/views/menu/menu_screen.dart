import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../viewmodels/profile_viewmodel.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/back_app_bar.dart';
import '../../widgets/gap.dart';
import '../downloads/downloads_screen.dart';

enum ApplicationStatus { inProgress, submitted, approved }

extension ApplicationStatusX on ApplicationStatus {
  String get label => switch (this) {
    ApplicationStatus.inProgress => 'Application in Progress',
    ApplicationStatus.submitted => 'Application Submitted',
    ApplicationStatus.approved => 'Application Approved',
  };
}

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({
    super.key,
    this.name,
    this.course,
    this.status = ApplicationStatus.inProgress,
    this.imageUrl,
  });

  final String? name;
  final String? course;
  final ApplicationStatus status;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileViewModel>();
    final displayName = name ?? profile.name;
    final displayCourse = course ?? profile.course;

    return AppScaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          AppSizes.appBarHeight + MediaQuery.paddingOf(context).top,
        ),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: AppSizes.appBarHeight,
            child: const BackAppBar(title: 'My Account'),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.paddingLarge,
            vertical: AppSizes.padding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _profileCard(
                displayName,
                displayCourse,
                imageUrl ?? profile.avatar,
              ),
              SizedBox(height: 12.h),
              _downloadsCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(offset: Offset(0, 1), blurRadius: 4, color: Colors.black12),
      ],
    ),
    child: child,
  );

  Widget _profileCard(
    String displayName,
    String displayCourse,
    dynamic image,
  ) => _card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: image is String
                  ? Image.network(
                      image,
                      width: 70.w,
                      height: 76.h,
                      fit: BoxFit.cover,
                    )
                  : image != null
                  ? Image.file(
                      image as dynamic,
                      width: 70.w,
                      height: 76.h,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/person.jpeg',
                      width: 70.w,
                      height: 76.h,
                      fit: BoxFit.cover,
                    ),
            ),
            const Gap(w: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName.isEmpty ? '—' : displayName,
                    style: AppTextStyles.subtitle.copyWith(
                      fontSize: 18.sp,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    displayCourse.isEmpty ? '—' : displayCourse,
                    style: AppTextStyles.condition,
                  ),
                  SizedBox(height: 6.h),
                  _statusTag(status),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Text(
          'My Account',
          style: AppTextStyles.body2.copyWith(
            fontSize: 12.sp,
            color: AppColors.primary,
          ),
        ),
      ],
    ),
  );

  Widget _downloadsCard(BuildContext context) => InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DownloadsScreen()),
      );
    },
    borderRadius: BorderRadius.circular(12),
    child: _card(
      child: Row(
        children: [
          Icon(
            Icons.description_outlined,
            color: AppColors.primary,
            size: 22.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Downloads',
                  style: AppTextStyles.body2.copyWith(
                    fontSize: 15.sp,
                    color: AppColors.primary,
                  ),
                ),
                Text('Guides & Forms', style: AppTextStyles.condition),
              ],
            ),
          ),
          Icon(Icons.download, size: 20.r, color: AppColors.gray),
        ],
      ),
    ),
  );

  Widget _statusTag(ApplicationStatus status) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.circle, size: 6.r, color: AppColors.gray),
      SizedBox(width: 6.w),
      Text(
        status.label,
        style: AppTextStyles.condition.copyWith(color: AppColors.gray),
      ),
    ],
  );
}
