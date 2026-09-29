import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';



class PasswordRule extends StatelessWidget {
  final String text;
  final bool isValid;

  const PasswordRule({
    super.key,
    required this.text,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 16.r,
            color: isValid ? AppColors.success : AppColors.gray,
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: AppTextStyles.condition.copyWith(
              color: isValid ? AppColors.success : AppColors.gray,
            ),
          ),
        ],
      ),
    );
  }
}