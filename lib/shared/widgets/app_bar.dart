import 'package:flutter/material.dart';
import 'package:smgi.connect/features/menu/menuscreen.dart';
import 'package:smgi.connect/notification/notification_screen.dart';
import 'package:smgi.connect/features/profile/profile_screen.dart';
import '../../../core/constants/app_colors.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      height: 65,
      padding: EdgeInsets.symmetric(horizontal: w * .04),
      decoration: BoxDecoration(color: AppColors.lightGray),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MyAccountPage(
                    name: 'Student',
                    course: 'Course not selected',
                    status: ApplicationStatus.inProgress,
                  ),
                ),
              );
            },
            child: const _IconBox(Icons.menu),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  );
                },
                child: const _IconBox(Icons.notifications_none),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
                child: Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.iconBoxStroke,
                      width: 1,
                    ),
                    color: AppColors.iconBoxFrame,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/person.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;

  const _IconBox(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        // Frame color (FFFFFF)
        color: AppColors.iconBoxFrame,

        // Corner radius
        borderRadius: BorderRadius.circular(12),

        // Stroke (inside, weight 1)
        border: Border.all(color: AppColors.iconBoxStroke, width: 1),

        // Drop shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          // Vector fill F5F7FA @ 10%
          color: AppColors.iconBoxFill,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: AppColors.navSelected),
      ),
    );
  }
}
