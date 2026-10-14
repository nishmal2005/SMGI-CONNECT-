import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../viewmodels/application_viewmodel.dart';
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

  Color get color => switch (this) {
        ApplicationStatus.inProgress => const Color(0xFFF1C40F),
        ApplicationStatus.submitted => const Color(0xFF0086FF),
        ApplicationStatus.approved => const Color(0xFF2ECC71),
      };
}

ApplicationStatus _mapStatus(String? raw) {
  final s = (raw ?? '').toLowerCase().replaceAll('_', '').trim();
  if (s.isEmpty) return ApplicationStatus.inProgress;
  if (s == 'approved' ||
      s == 'completed' ||
      s == 'admitted' ||
      s == 'verified') {
    return ApplicationStatus.approved;
  }
  if (s == 'submitted' ||
      s == 'underreview' ||
      s == 'inreview' ||
      s == 'pending') {
    return ApplicationStatus.submitted;
  }
  return ApplicationStatus.inProgress;
}

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().load();
      context.read<ApplicationViewModel>().loadStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileViewModel>();
    final app = context.watch<ApplicationViewModel>();

    final status = _mapStatus(app.status);

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
                profile.name,
                profile.course,   // ← already "engineeRing · Mtech"
                profile.avatar,
                status,
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
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 4,
              color: Colors.black12,
            ),
          ],
        ),
        child: child,
      );

  Widget _profileCard(
    String displayName,
    String displayCourse,
    dynamic image,
    ApplicationStatus status,
  ) =>
      _card(
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
                          errorBuilder: (_, __, ___) => Image.asset(
                            'assets/images/person.jpeg',
                            width: 70.w,
                            height: 76.h,
                            fit: BoxFit.cover,
                          ),
                        )
                      : image != null
                          ? Image.file(
                              image,
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
          Icon(Icons.circle, size: 6.r, color: status.color),
          SizedBox(width: 6.w),
          Text(
            status.label,
            style: AppTextStyles.condition.copyWith(color: status.color),
          ),
        ],
      );
}