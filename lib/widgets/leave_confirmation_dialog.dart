import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';

import 'gradient_button.dart';

class LeaveConfirmationDialog extends StatelessWidget {
  final VoidCallback onLeave;

  const LeaveConfirmationDialog({super.key, required this.onLeave});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/warningicon.png',
              height: 60.h,
            ),
            SizedBox(height: 15.h),
            Text(
              'Leave this page?',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Text(
              'Your admission form progress will be lost. '
              'Are you sure you want to go back?',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.black,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE84545)),
                  backgroundColor: const Color(0xFFFFF3F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                onPressed: onLeave,
                child: Text(
                  'Leave anyway',
                  style: TextStyle(
                    color: const Color(0xFFE84545),
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            GradientButton(
              text: 'Stay on this page',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}