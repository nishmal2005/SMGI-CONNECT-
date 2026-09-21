import 'package:flutter/material.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/features/profile/profile_screen.dart';
import 'package:smgi.connect/notification/notification_screen.dart';

class BackAppBar extends StatelessWidget {
  final String title;
  const BackAppBar({super.key, this.title = "Profile"});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      height: 65,
      padding: EdgeInsets.symmetric(horizontal: w * .04),
      decoration: const BoxDecoration(color: AppColors.lightGray),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context); // 🔙 Go back to previous page
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.accent,
            ), // 🖤 Black Icon
          ),

          // 🔹 Title
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(), // Pushes icons to the right

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

              // 👤 Profile Navigation
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

/// 📦 Reusable Icon Button Box
class _IconBox extends StatelessWidget {
  final IconData icon;
  const _IconBox(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.iconBoxStroke, width: 1),
        color: AppColors.iconBoxFrame,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: AppColors.accent),
    );
  }
}
