import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';

class NavItem extends StatelessWidget {
  final String assetPath;
  final bool active;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.assetPath,
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
        width: 70.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? AppColors.navBg.withValues(alpha: 0.06)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: SvgPicture.asset(
          assetPath,
          width: 25.r,
          height: 25.r,
          colorFilter: ColorFilter.mode(
            active ? AppColors.navSelected : AppColors.navNotSelected,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
