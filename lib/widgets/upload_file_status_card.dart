import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';


class UploadFileStatusCard extends StatelessWidget {
  final String? fileName;
  final VoidCallback? onClear;

  const UploadFileStatusCard({
    super.key,
    this.fileName,
    this.onClear,
  });

  bool get _hasFile => fileName != null && fileName!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/fileicon.png',
                height: 22.h,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  _hasFile ? fileName! : 'No file selected yet.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    color: _hasFile
                        ? AppColors.black
                        : const Color(0xFF9BA3B0),
                  ),
                ),
              ),
              if (_hasFile)
                GestureDetector(
                  onTap: onClear,
                  child: Icon(
                    Icons.close,
                    color: const Color(0xFF9BA3B0),
                    size: 18.r,
                  ),
                )
              else
                Icon(
                  Icons.close,
                  color: const Color(0xFF9BA3B0),
                  size: 18.r,
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            height: 2.h,
            width: 160.w,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}