import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/core/constants/app_assets.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_sizes.dart';
import 'package:smgi.connect/viewmodels/notification_viewmodel.dart';
import 'package:smgi.connect/views/notification/notification_screen.dart';
import 'package:smgi.connect/views/profile/profile_screen.dart';

class BackAppBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final bool showActions;

  const BackAppBar({
    super.key,
    this.title = 'Profile',
    this.onBack,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.appBarHeight,
      padding: EdgeInsets.symmetric(horizontal: AppSizes.padding),
      color: AppColors.lightGray,
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: onBack ?? () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: AppColors.accent, size: 22.r),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (showActions) ...[
            _IconBox(
              assetPath: AppAssets.bellDotIcon,
              onTap: () {
                // Nudge the notification VM so the list is fresh on open.
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
        ],
      ),
    );
  }
}

/// Rounded icon button used by both [BackAppBar] and [HomeAppBar].
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

/// Circular avatar with a soft blue border. Tapping opens the profile.
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