import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/viewmodels/auth_viewmodel.dart';

import '../../widgets/auth_background.dart';
import '../../widgets/gap.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/gradient_text_field.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final input = _input.text.trim();
    if (input.isEmpty) {
      _snack('Enter your email to continue.');
      return;
    }

    final auth = context.read<AuthViewModel>();
    final ok = await auth.sendOtp(input);
    if (!mounted) return;

    if (ok) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OtpScreen(input: input)),
      );
    } else {
      _snack(auth.errorMessage ?? 'Unable to send OTP.');
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                Gap(h: 134),

                // ── Logo ───────────────────────────────
                Hero(
                  tag: 'logo',
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'SMGI ',
                          style: AppTextStyles.logoGold,
                        ),
                        TextSpan(
                          text: 'Connect',
                          style: AppTextStyles.logoWhite,
                        ),
                      ],
                    ),
                  ),
                ),

                Gap(h: 80),

                // ── Headline ───────────────────────────
                Text(
                  'Login to continue',
                  style: AppTextStyles.subtitle,
                ),

                Gap(h: 80),

                // ── Email input ────────────────────────
                GradientTextField(
                  hint: 'Enter your email',
                  controller: _input,
                  keyboardType: TextInputType.emailAddress,
                ),

                Gap(h: 80),

                // ── Continue ───────────────────────────
                GradientButton(
                  text: 'Continue',
                  enabled: !auth.isLoading,
                  onTap: _continue,
                ),

                Gap(h: 29),

                // ── Terms ──────────────────────────────
                Text(
                  'By continuing, you agree to our terms',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}