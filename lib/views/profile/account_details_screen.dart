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
import 'edit_profile_sheet.dart';

class AccountDetailsScreen extends StatelessWidget {
  const AccountDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    return AppScaffold(
      padding: EdgeInsets.zero,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          AppSizes.appBarHeight + MediaQuery.paddingOf(context).top,
        ),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: AppSizes.appBarHeight,
            child: const BackAppBar(title: 'Account Details'),
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
            children: [
              SizedBox(height: 12.h),

              // ── Avatar ─────────────────────────────
              _AvatarLarge(image: vm.avatar),

              SizedBox(height: 12.h),

              Text(
                vm.name,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),

              SizedBox(height: 8.h),

              // ── Edit link ──────────────────────────
              InkWell(
                onTap: () => showProfileEditSheet(context),
                borderRadius: BorderRadius.circular(6.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 16.r,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // ── Details card ───────────────────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Account Details', style: AppTextStyles.pageTitle),
                    const Gap(h: 12),
                    Divider(height: 1, color: AppColors.lightGray),
                    const Gap(h: 12),

                    _DetailRow(label: 'Name', value: vm.name),
                    const Gap(h: 12),
                    _DetailRow(label: 'Email', value: vm.email),
                    const Gap(h: 12),
                    _DetailRow(label: 'Mobile', value: vm.phone),
                    const Gap(h: 12),
                    _DetailRow(
                      label: 'Course',
                      value: vm.course,
                      valueColor: AppColors.primary,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Private widgets
// ─────────────────────────────────────────────────────

class _AvatarLarge extends StatelessWidget {
  final dynamic image;
  const _AvatarLarge({this.image});

  @override
  Widget build(BuildContext context) {
    final size = 96.r;
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 2.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: image != null
            ? Image.file(image as dynamic, fit: BoxFit.cover)
            : Image.asset('assets/images/person.jpeg', fit: BoxFit.cover),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.inputHint),
        SizedBox(height: 4.h),
        Text(
          value,
          style: AppTextStyles.inputText.copyWith(
            color: valueColor ?? AppColors.black,
          ),
        ),
      ],
    );
  }
}
