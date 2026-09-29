import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';


class NavItem extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30.r),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 56.h,
        width: 66.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? AppColors.navBg.withValues(alpha: 0.06)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Icon(
          icon,
          size: 24.r,
          color: active
              ? AppColors.navSelected
              : AppColors.navNotSelected,
        ),
      ),
    );
  }
}