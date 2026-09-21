import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/features/auth/provider/auth_provider.dart';
import 'package:smgi.connect/features/auth/screens/otp_screen.dart';
import 'package:smgi.connect/shared/widgets/auth/auth_background.dart';
import 'package:smgi.connect/shared/widgets/auth/gradient_text_field.dart';
import 'package:smgi.connect/shared/widgets/gap.dart';
import 'package:smgi.connect/shared/widgets/gradient_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _requestReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.requestPasswordReset(email);
    if (!mounted) return;

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OtpScreen(input: email)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Unable to send OTP.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Gap(h: 134),
                Hero(
                  tag: 'logo',
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(text: 'SMGI ', style: AppTextStyles.logoGold),
                        TextSpan(
                          text: 'Connect',
                          style: AppTextStyles.logoWhite,
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(h: 80),
                const Text(
                  'Verify Your Account',
                  style: AppTextStyles.subtitle,
                ),
                const Gap(h: 12),
                const Text(
                  'Enter your email to receive a password reset code.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.center,
                ),
                const Gap(h: 48),
                GradientTextField(
                  hint: 'Enter your email',
                  controller: _emailController,
                ),
                const Gap(h: 48),
                GradientButton(text: 'Continue', onTap: _requestReset),
                const Gap(h: 29),
                const Text(
                  'A verification code will be sent to your email.',
                  style: AppTextStyles.caption,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
