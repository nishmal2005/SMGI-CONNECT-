import 'package:flutter/material.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/features/auth/provider/auth_provider.dart';
import 'package:smgi.connect/shared/widgets/app_scaffold.dart';
import 'package:smgi.connect/shared/widgets/gap.dart';
import 'package:smgi.connect/shared/widgets/logout_dialog.dart';
import 'package:smgi.connect/shared/widgets/responsive_helper.dart';
//import 'package:http/http.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);

    return AppScaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: isTablet ? 500 : double.infinity,
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Back button
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.arrow_back),
                  color: AppColors.accent,
                  onPressed: () => Navigator.pop(context),
                ),

                const Gap(h: 8),

                /// Title
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),

                const Gap(h: 16),

                /// Main Card
                _card(
                  child: Column(
                    children: [
                      _row(
                        icon: Icons.key,
                        title: 'Change Password',
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      Divider(height: 1, color: AppColors.lightGray),
                      _row(
                        icon: Icons.phone_android,
                        title: 'App version',
                        trailing: const Text(
                          '1.0.0',
                          style: TextStyle(fontSize: 12, color: AppColors.gray),
                        ),
                      ),
                    ],
                  ),
                ),

                const Gap(h: 20),

                /// Logout Card
                _card(
                  child: _row(
                    icon: Icons.logout,
                    title: 'Logout',
                    titleColor: Colors.red,
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.red,
                    ),
                    onTap: () {
                      showLogoutDialog(
                        context,
                        onConfirmLogout: () {
                          context.read<AuthProvider>().logout(context);
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

  /// Card helper (keeps UI consistent)
  Widget _card({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(offset: Offset(0, 1), blurRadius: 2, color: Colors.black12),
        ],
      ),
      child: child,
    );
  }

  /// Row helper
  Widget _row({
    required IconData icon,
    required String title,
    required Widget trailing,
    Color titleColor = AppColors.black,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 18, color: titleColor),
            const Gap(w: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 14, color: titleColor),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
