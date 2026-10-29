import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smgi_connect/core/constants/app_assets.dart';
import 'package:smgi_connect/core/constants/app_colors.dart';
import 'package:smgi_connect/core/constants/app_sizes.dart';
import 'package:smgi_connect/core/navigation/nav_guard.dart';
import 'package:smgi_connect/viewmodels/notification_viewmodel.dart';
import 'package:smgi_connect/viewmodels/profile_viewmodel.dart';
import 'package:smgi_connect/views/menu/menu_screen.dart';
import 'package:smgi_connect/views/notification/notification_screen.dart';
import 'package:smgi_connect/views/profile/profile_screen.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  void initState() {
    super.initState();
    // Refresh user-scoped data for the CURRENT session as soon as the
    // home app bar is mounted (i.e. right after login/register).
    // This prevents showing the previous user's unread count / initial.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProfileViewModel>().load();
      context.read<NotificationViewModel>().load();
    });
  }

  // ── Guarded navigations (NavGuard survives remounts) ──────────────

  void _openMyAccount() {
    NavGuard.push(
      context,
      const MyAccountPage(),
      key: '/my-account',
    );
  }

  void _openNotifications() {
    NavGuard.push(
      context,
      const NotificationsScreen(),
      key: '/notifications',
    );
  }

  void _openProfile() {
    NavGuard.push(
      context,
      const ProfileScreen(),
      key: ProfileScreen.routeName, // '/profile'
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.appBarHeight,
      color: AppColors.lightGray,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Left: menu icon → My Account ───────────
          _IconBox(
            assetPath: AppAssets.menuIcon,
            onTap: _openMyAccount,
          ),

          // ── Right: notifications + avatar ──────────
          Row(
            children: [
              // ── Notification bell with unread badge ──
              Consumer<NotificationViewModel>(
                builder: (context, vm, _) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _IconBox(
                        assetPath: AppAssets.bellDotIcon,
                        onTap: _openNotifications,
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

              // ── Avatar with letter initial ──────────
              _AvatarButton(onTap: _openProfile),
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

  const _IconBox({this.assetPath, this.onTap}) : icon = null;

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

// ── Avatar button — letter initial ───────────────────
class _AvatarButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _AvatarButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    // Watch the profile VM for the user's name.
    final vm = context.watch<ProfileViewModel>();
    final initial = _initial(vm.name);

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
          initial,
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
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    return String.fromCharCode(trimmed.runes.first).toUpperCase();
  }
}