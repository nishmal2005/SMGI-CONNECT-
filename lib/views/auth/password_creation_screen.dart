import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart' show AppTextStyles;
import 'package:smgi.connect/viewmodels/auth_viewmodel.dart';


import '../../widgets/auth_background.dart';
import '../../widgets/gap.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/password_field.dart';
import '../../widgets/password_rule.dart';
import 'login_screen.dart';

class PasswordCreationScreen extends StatelessWidget {
  const PasswordCreationScreen({super.key});

  Future<void> _submit(BuildContext context) async {
    final auth = context.read<AuthViewModel>();
    final isForgot = auth.flow == AuthFlow.forgotPassword;
    final ok = isForgot ? await auth.resetPassword() : await auth.register();

    if (!context.mounted) return;

    if (ok) {
      auth.clearPasswords();
      auth.setFlow(AuthFlow.register);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Something went wrong.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final isForgot = auth.flow == AuthFlow.forgotPassword;

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(h: 130),
                Center(
                  child: Hero(
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
                ),
                Gap(h: 84),
                Center(
                  child: Text(
                    isForgot
                        ? 'Reset Your Password'
                        : 'Create Your Password',
                    style: AppTextStyles.subtitle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Gap(h: 8),
                Center(
                  child: Text(
                    'Your safety starts with a strong password.',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                ),
                Gap(h: 26),

                // ── Password ───────────────────────────
                Text('Password', style: AppTextStyles.caption),
                Gap(h: 8),
                PasswordField(
                  isValid: auth.isPasswordValid,
                  onChanged: auth.setPassword,
                ),
                Gap(h: 24),

                // ── Confirm ────────────────────────────
                Text(
                  'Confirm Password',
                  style: AppTextStyles.caption,
                ),
                Gap(h: 8),
                PasswordField(
                  isValid: auth.isConfirmPasswordValid,
                  onChanged: auth.setConfirmPassword,
                ),
                Gap(h: 28),

                // ── Rules ──────────────────────────────
                PasswordRule(
                  text: 'At least 8 characters',
                  isValid: auth.hasMinLength,
                ),
                PasswordRule(
                  text: 'One uppercase',
                  isValid: auth.hasUppercase,
                ),
                PasswordRule(text: 'One number', isValid: auth.hasNumber),
                PasswordRule(
                  text: 'One special character',
                  isValid: auth.hasSpecial,
                ),
                Gap(h: 60),

                GradientButton(
                  text: isForgot ? 'Reset Password' : 'Set Password',
                  enabled: auth.canSubmitPassword && !auth.isLoading,
                  onTap: () => _submit(context),
                ),
                Gap(h: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}