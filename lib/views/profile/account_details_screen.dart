import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../viewmodels/profile_viewmodel.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/back_app_bar.dart';
import 'edit_profile_sheet.dart';

class AccountDetailsScreen extends StatelessWidget {
  const AccountDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    return AppScaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          AppSizes.appBarHeight + MediaQuery.paddingOf(context).top,
        ),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: AppSizes.appBarHeight,
            child: const BackAppBar(title: '', showActions: false),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.padding,
            vertical: AppSizes.padding,
          ),
          child: Column(
            children: [
              SizedBox(height: 4.h),

              // ── Name (above avatar) ────────────────
              Text(
                vm.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4,
                  color: AppColors.black,
                ),
              ),

              SizedBox(height: 5.h),

              // ── Avatar ─────────────────────────────
              _AvatarLarge(image: vm.avatar),

              SizedBox(height: 4.h),

              // ── Edit link (very close to avatar) ───
              InkWell(
                onTap: () => showProfileEditSheet(context),
                borderRadius: BorderRadius.circular(6.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 18.r,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16.sp,
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
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Details',
                      style: AppTextStyles.pageTitle.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Divider(
                      height: 1,
                      thickness: 0.5,
                      color: AppColors.lightGray,
                    ),
                    SizedBox(height: 14.h),

                    _DetailRow(label: 'Name', value: vm.name),
                    SizedBox(height: 10.h),
                    _DetailRow(label: 'Email', value: vm.email),
                    SizedBox(height: 10.h),
                    _DetailRow(label: 'Mobile', value: vm.phone),
                    SizedBox(height: 10.h),
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
    final size = 120.r;
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 1.w),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.inputHint.copyWith(fontSize: 12.sp)),
        SizedBox(width: 16.w),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.inputText.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: valueColor ?? AppColors.black,
            ),
          ),
        ),
      ],
    );
  }
}
