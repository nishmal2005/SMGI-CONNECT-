import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smgi.connect/features/document/vault_screen.dart';
import 'package:smgi.connect/features/homescreen/homescreen.dart';
import 'package:smgi.connect/features/payment/payment_history_screen.dart';
import 'package:smgi.connect/features/referral/referral_mainScreen.dart';
import 'package:smgi.connect/shared/widgets/app_scaffold.dart';

import 'nav_item.dart';

class HomeBottomNav extends StatefulWidget {
  const HomeBottomNav({super.key});

  @override
  State<HomeBottomNav> createState() => _HomeBottomNavState();
}

class _HomeBottomNavState extends State<HomeBottomNav> {
  int selectedIndex = 0;

  final icons = const [
    Icons.home,
    Icons.credit_card,
    Icons.description,
    Icons.person,
  ];

  final pages = const [
    HomeScreen(),
    DocumentVaultScreen(),
    PaymentHistoryPage(),
    ReferralHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final navHeight = size.height * 0.075;
    final padding = size.width * 0.04;
    final radius = size.width * 0.08;

    return AppScaffold(
      body: pages[selectedIndex],

      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(padding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              height: navHeight,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: const Color.fromARGB(0, 71, 59, 59), // 1A = 10% opacity

                borderRadius: BorderRadius.circular(30),

                // 🔥 Inner shadow (FFFFFF - 25% blur 2)
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(64, 223, 222, 222),
                    blurRadius: 2,
                    spreadRadius: -1,
                    offset: Offset(0, -1),
                  ),
                ],

                // Glass boundary line
                border: Border.all(
                  color: const Color.fromARGB(178, 255, 255, 255),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  icons.length,
                  (index) => NavItem(
                    icon: icons[index],
                    active: selectedIndex == index,
                    onTap: () {
                      setState(() => selectedIndex = index);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
