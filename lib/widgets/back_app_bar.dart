// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:smgi_connect/core/constants/app_assets.dart';
import 'package:smgi_connect/core/constants/app_colors.dart';
import 'package:smgi_connect/core/constants/app_sizes.dart';
import 'package:smgi_connect/viewmodels/notification_viewmodel.dart';
import 'package:smgi_connect/viewmodels/profile_viewmodel.dart';
import 'package:smgi_connect/views/notification/notification_screen.dart';
import 'package:smgi_connect/views/profile/profile_screen.dart';

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
            // ── Bell icon with unread badge ──
            Consumer<NotificationViewModel>(
              builder: (context, vm, _) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _IconBox(
                      assetPath: AppAssets.bellDotIcon,
                      onTap: () {
                        vm.load();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationsScreen(),
                          ),
                        );
                      },
                    ),
                    if (vm.unreadCount > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 16.r,
                            minHeight: 16.r,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            vm.unreadCount > 9 ? '9+' : '${vm.unreadCount}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            SizedBox(width: 12.w),

            // ── Avatar with letter initial ──
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
        alignment: Alignment.center,
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
                width: 24.r,
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

/// Rounded avatar box showing the user's first initial.
/// Tapping opens the profile.
class _AvatarButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _AvatarButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    // Watch the shared ProfileViewModel so the initial
    // updates as soon as the profile loads.
    final name = context.watch<ProfileViewModel>().name;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSizes.iconBox,
        width: AppSizes.iconBox,
        alignment: Alignment.center,
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
        child: Text(
          _initial(name),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.accent,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  /// First character of the user's name, uppercased.
  /// Falls back to '?' when the name is empty.
  String _initial(String name) {
    final t = name.trim();
    if (t.isEmpty) return '?';
    return t.characters.first.toUpperCase();
  }
}
