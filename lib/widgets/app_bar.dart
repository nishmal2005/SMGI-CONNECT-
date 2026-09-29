import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_sizes.dart';
import 'package:smgi.connect/viewmodels/notification_viewmodel.dart';
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
            icon: Icons.menu,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),

          // ── Right: notifications + avatar ──────────
          Row(
            children: [
              _IconBox(
                icon: Icons.notifications_none,
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
  final IconData icon;
  final VoidCallback? onTap;

  const _IconBox({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSizes.iconBox,
        width: AppSizes.iconBox,
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
        child: Icon(icon, color: AppColors.accent, size: 20.r),
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
          child: Image.asset(
            'assets/images/person.jpeg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}