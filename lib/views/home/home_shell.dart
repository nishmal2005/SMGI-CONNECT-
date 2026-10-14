import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_assets.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/nav_item.dart';
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

  /// Tracks which tabs have been opened at least once.
  /// Unvisited tabs never mount, so they never fire their initState APIs.
  final Set<int> _visited = {0};

  static const _icons = <String>[
    AppAssets.homeIcon,
    AppAssets.fileIcon,
    AppAssets.creditCardIcon,
    AppAssets.handshakeIcon,
  ];

  void _onTabSelected(int i) {
    if (i == _index) return;
    setState(() {
      _index = i;
      _visited.add(i);
    });
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const DocumentVaultScreen();
      case 2:
        return const PaymentHistoryScreen();
      case 3:
        return const ReferralHistoryScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.zero,
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    if (_visited.length == 1) {
      return _buildPage(_index);
    }
    return IndexedStack(
      index: _index,
      children: List.generate(
        _icons.length,
        (i) => _visited.contains(i) ? _buildPage(i) : const SizedBox.shrink(),
      ),
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
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
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
                (i) => NavItem(
                  assetPath: _icons[i],
                  active: _index == i,
                  onTap: () => _onTabSelected(i),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
