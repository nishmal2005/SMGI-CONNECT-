import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/network/api_client.dart';
import '../home/home_shell.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Show the splash for at least 3 seconds.
    final minimumSplash = Future<void>.delayed(
      const Duration(seconds: 3),
    );

    // Check the stored token in parallel.
    final api = context.read<ApiClient>();
    final loggedIn = await api.isLoggedIn;

    if (kDebugMode) {
      final token = await api.accessToken;
      debugPrint(
        '[SPLASH] isLoggedIn=$loggedIn '
        'token=${token == null ? "null" : "len=${token.length}"}',
      );
    }

    await minimumSplash;
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            loggedIn ? const HomeShell() : const OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/Splashscreen.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}