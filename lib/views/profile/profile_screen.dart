import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../viewmodels/profile_viewmodel.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/back_app_bar.dart';
import 'account_details_screen.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    return AppScaffold(
      padding: EdgeInsets.zero,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          AppSizes.appBarHeight + MediaQuery.paddingOf(context).top,
        ),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: AppSizes.appBarHeight,
            child: const BackAppBar(title: 'Profile'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingLarge,
          vertical: AppSizes.padding,
        ),
        child: Column(
          children: [
            // ── Avatar card ────────────────────────
            Container(
              height: 90.h,
              margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _Avatar(image: vm.avatar),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          vm.name.isEmpty ? '—' : vm.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          vm.course.isEmpty ? '—' : vm.course,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.condition,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Tiles ──────────────────────────────
            _Tile(
              title: 'My Account',
              isFirst: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AccountDetailsScreen(),
                  ),
                );
              },
            ),
            _Tile(
              title: 'Settings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
            _Tile(
              title: 'Help',
              isLast: true,
              onTap: () {
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Private widgets
// ─────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final dynamic image;
  const _Avatar({this.image});

  @override
  Widget build(BuildContext context) {
    final size = 55.r;
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 2.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: image != null
            ? Image.file(image as dynamic, fit: BoxFit.cover)
            : Image.asset(
                'assets/images/person.jpeg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.person, color: AppColors.primary),
              ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  const _Tile({
    required this.title,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? Radius.circular(12.r) : Radius.zero,
        bottom: isLast ? Radius.circular(12.r) : Radius.zero,
      ),
      child: Container(
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: isFirst ? Radius.circular(12.r) : Radius.zero,
            bottom: isLast ? Radius.circular(12.r) : Radius.zero,
          ),
          border: Border.all(color: const Color(0xFFD1D1D1), width: 0.75.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16.r, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
