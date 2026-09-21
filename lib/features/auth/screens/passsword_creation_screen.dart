import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/features/auth/provider/auth_provider.dart';
import 'package:smgi.connect/features/auth/screens/login_screen_main.dart';
import 'package:smgi.connect/features/auth/widgets/password_field.dart';
import 'package:smgi.connect/features/auth/widgets/password_rule.dart';
import '../../../shared/widgets/auth/auth_background.dart';
import '../../../shared/widgets/gap.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../core/constants/app_text_styles.dart';

class PasswordCreationScreen extends StatelessWidget {
  const PasswordCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final auth = context.watch<AuthProvider>();

    final isForgot = auth.flow == AuthFlow.forgotPassword;

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TOP SPACE
                const Gap(h: 130),

                /// LOGO
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

                /// TITLE
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    isForgot ? 'Reset Your Password' : 'Create Your Password',
                    style: AppTextStyles.subtitle,
                    textAlign: TextAlign.center,
                  ),
                ),

                const Gap(h: 8),

                /// SUBTITLE
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Your safety starts with a strong password.',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                ),

                const Gap(h: 26),

                /// PASSWORD
                const Text('Password', style: AppTextStyles.caption),
                const Gap(h: 8),
                PasswordField(
                  isValid: auth.isPasswordValid,
                  onChanged: auth.setPassword,
                ),

                Gap(h: size.height * 0.04),

                /// CONFIRM PASSWORD
                const Text('Confirm Password', style: AppTextStyles.caption),
                const Gap(h: 8),
                PasswordField(
                  isValid: auth.isConfirmPasswordValid,
                  onChanged: auth.setConfirmPassword,
                ),

                const Gap(h: 28),

                /// PASSWORD RULES
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

                /// BUTTON
                GradientButton(
                  text: isForgot ? 'Reset Password' : 'Set Password',
                  enabled: auth.canSubmitPassword,
                  onTap: () async {
                    bool success;

                    if (isForgot) {
                      success = await auth.resetPassword();
                    } else {
                      success = await auth.register(phone: '', fullName: '');
                    }

                    if (success) {
                      auth.setPassword('');
                      auth.setConfirmPassword('');

                      // 🔹 reset flow after success
                      auth.setFlow(AuthFlow.register);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen2()),
                      );
                    } else {
                      // 🔴 SHOW ERROR HERE
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Something went wrong')),
                      );
                    }
                  },
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
