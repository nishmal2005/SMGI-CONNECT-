import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/features/auth/provider/auth_provider.dart';
import 'package:smgi.connect/features/auth/screens/login_screen_main.dart';
import 'package:smgi.connect/features/auth/widgets/password_field.dart';
import 'package:smgi.connect/features/auth/widgets/password_rule.dart';
import 'package:smgi.connect/shared/widgets/auth/auth_background.dart';
import 'package:smgi.connect/shared/widgets/gap.dart';
import 'package:smgi.connect/shared/widgets/gradient_button.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  Future<void> _resetPassword(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final success = await auth.resetPassword();
    if (!context.mounted) return;

    if (success) {
      auth.setFlow(AuthFlow.register);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen2()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Unable to reset password.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(h: 130),
                Center(
                  child: Hero(
                    tag: 'logo',
                    child: RichText(
                      text: const TextSpan(
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
                ),
                const Gap(h: 84),
                const Center(
                  child: Text(
                    'Create New Password',
                    style: AppTextStyles.subtitle,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Gap(h: 8),
                const Center(
                  child: Text(
                    'Your safety starts with a strong password.',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Gap(h: 26),
                const Text('Password', style: AppTextStyles.caption),
                const Gap(h: 8),
                PasswordField(
                  isValid: auth.isPasswordValid,
                  onChanged: auth.setPassword,
                ),
                const Gap(h: 24),
                const Text('Confirm Password', style: AppTextStyles.caption),
                const Gap(h: 8),
                PasswordField(
                  isValid: auth.isConfirmPasswordValid,
                  onChanged: auth.setConfirmPassword,
                ),
                const Gap(h: 28),
                PasswordRule(
                  text: 'At least 8 characters',
                  isValid: auth.hasMinLength,
                ),
                PasswordRule(text: 'One uppercase', isValid: auth.hasUppercase),
                PasswordRule(text: 'One number', isValid: auth.hasNumber),
                PasswordRule(
                  text: 'One special character',
                  isValid: auth.hasSpecial,
                ),
                const Gap(h: 60),
                GradientButton(
                  text: 'Create Password',
                  enabled: auth.canSubmitPassword,
                  onTap: () => _resetPassword(context),
                ),
                const Gap(h: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
