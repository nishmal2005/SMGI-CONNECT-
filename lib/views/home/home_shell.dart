import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_assets.dart';
import 'package:smgi.connect/widgets/nav_item.dart';

import '../documents/document_vault_screen.dart';
import '../payments/payment_history_screen.dart';
import '../referrals/referral_history_screen.dart';
import 'home_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _icons = <String>[
    AppAssets.homeIcon,
    AppAssets.fileIcon,
    AppAssets.creditCardIcon,
    AppAssets.handshakeIcon,
  ];

  static const _pages = <Widget>[
    HomeScreen(),
    DocumentVaultScreen(),
    PaymentHistoryScreen(),
    ReferralHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 62.h,
            // padding: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              // Slightly transparent white so the frosted blur shows
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(32.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, -2),
                ),
              ],
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.7),
                width: 1.w,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                _icons.length,
                (i) => Row(
                  children: [
                    NavItem(
                      assetPath: _icons[i],
                      active: _index == i,
                      onTap: () => setState(() => _index = i),
                    ),
                    if (i < _icons.length - 1) SizedBox(width: 8.w),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
