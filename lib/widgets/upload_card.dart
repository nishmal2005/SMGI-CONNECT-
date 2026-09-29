import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';

import 'gap.dart';

class UploadCard extends StatelessWidget {
  final double height;
  final double width;
  final String assetPath;
  final bool isFileSelected;
  final VoidCallback? onTap;

  const UploadCard({
    super.key,
    required this.height,
    required this.width,
    required this.assetPath,
    this.isFileSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F7FF),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFF9BA3B0), width: 1.w),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(assetPath, height: 70.h),
              const Gap(h: 12),
              Text(
                'Click or drag file to this area to upload',
                style: AppTextStyles.body3,
              ),
              const Gap(h: 8),
              Text(
                isFileSelected ? '1 file selected' : 'No file selected',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}