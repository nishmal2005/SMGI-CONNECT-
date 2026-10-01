import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_sizes.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/viewmodels/auth_viewmodel.dart';
import 'package:smgi.connect/views/auth/forgot_password_screen.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/back_app_bar.dart';
import '../../widgets/gap.dart';
import '../../widgets/logout_dialog.dart';
import '../../widgets/responsive_helper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  /// Bump this when you bump `pubspec.yaml` version.
  static const String _appVersion = '1.0.0';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          AppSizes.appBarHeight + MediaQuery.paddingOf(context).top,
        ),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: AppSizes.appBarHeight,
            child: const BackAppBar(title: 'Settings'),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: Container(
            width: Responsive.contentMaxWidth(context),
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingLarge,
              vertical: AppSizes.padding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Account card ───────────────────────
                _Card(
                  child: Column(
                    children: [
                      _Row(
                        icon: Icons.key,
                        title: 'Change Password',
                        trailing: Icon(
                          Icons.chevron_right,
                          size: 20.r,
                          color: AppColors.gray,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen(),
                            ),
                          );
                        },
                      ),
                      Divider(
                        height: 1,
                        color: AppColors.lightGray,
                        indent: 16.w,
                        endIndent: 16.w,
                      ),
                      _Row(
                        icon: Icons.phone_android,
                        title: 'App version',
                        trailing: Text(
                          _appVersion,
                          style: AppTextStyles.condition,
                        ),
                      ),
                    ],
                  ),
                ),

                const Gap(h: 20),

                // ── Logout card ────────────────────────
                _Card(
                  child: _Row(
                    icon: Icons.logout,
                    title: 'Logout',
                    titleColor: const Color(0xFFE94B4B),
                    trailing: Icon(
                      Icons.chevron_right,
                      size: 20.r,
                      color: const Color(0xFFE94B4B),
                    ),
                    onTap: () {
                      showLogoutDialog(
                        context,
                        onConfirmLogout: () {
                          // Fire-and-forget: logout clears tokens and
                          // resets auth state, then the app can redirect.
                          context.read<AuthViewModel>().logout();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Reusable row + card for this screen only.
// ─────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final Color titleColor;
  final VoidCallback? onTap;

  const _Row({
    required this.icon,
    required this.title,
    this.trailing,
    this.titleColor = AppColors.black,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radius),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Icon(icon, size: 18.r, color: titleColor),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: titleColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
