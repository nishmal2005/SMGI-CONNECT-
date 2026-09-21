import 'package:flutter/material.dart';
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
    final size = MediaQuery.of(context).size;

    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        height: size.height * 0.066,
        width: size.width * 0.22,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? AppColors.navBg.withOpacity(0.06)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: AppColors.navBg.withOpacity(0.06),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 24,
          color: active ? AppColors.navSelected : AppColors.navNotSelected,
        ),
      ),
    );
  }
}
