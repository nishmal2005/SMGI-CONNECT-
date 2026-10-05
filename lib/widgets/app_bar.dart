import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/core/constants/app_assets.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_sizes.dart';
import 'package:smgi.connect/viewmodels/notification_viewmodel.dart';
import 'package:smgi.connect/views/menu/menu_screen.dart';
import 'package:smgi.connect/views/notification/notification_screen.dart';
import 'package:smgi.connect/views/profile/profile_screen.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.appBarHeight,
      //padding: EdgeInsets.symmetric(horizontal: AppSizes.padding),
      color: AppColors.lightGray,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Left: menu icon → Profile ──────────────
          _IconBox(
            assetPath: AppAssets.menuIcon,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyAccountPage()),
              );
            },
          ),

          // ── Right: notifications + avatar ──────────
          Row(
            children: [
              _IconBox(
                assetPath: AppAssets.bellDotIcon,
                onTap: () {
                  // Refresh before showing the list.
                  context.read<NotificationViewModel>().load();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  );
                },
              ),
              SizedBox(width: 12.w),
              _AvatarButton(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Reusable icon button box ─────────────────────────
class _IconBox extends StatelessWidget {
  final IconData? icon;
  final String? assetPath;
  final VoidCallback? onTap;

  const _IconBox({this.icon, this.assetPath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSizes.iconBox,
        width: AppSizes.iconBox,
        alignment: Alignment.center, // lets the child keep its own size
        decoration: BoxDecoration(
          color: AppColors.iconBoxFrame,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.iconBoxStroke, width: 1.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: assetPath != null
            ? SvgPicture.asset(
                assetPath!,
                width: 24.r, // change this value to resize the icon
                height: 24.r,
                colorFilter: const ColorFilter.mode(
                  AppColors.accent,
                  BlendMode.srcIn,
                ),
              )
            : Icon(icon, color: AppColors.accent, size: 20.r),
      ),
    );
  }
}

// ── Avatar button ────────────────────────────────────
class _AvatarButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _AvatarButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSizes.iconBox,
        width: AppSizes.iconBox,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.iconBoxStroke, width: 1.w),
          color: AppColors.iconBoxFrame,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: Image.asset('assets/images/person.jpeg', fit: BoxFit.cover),
        ),
      ),
    );
  }
}