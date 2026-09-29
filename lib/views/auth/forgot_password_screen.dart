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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final email = _email.text.trim();
    if (email.isEmpty) return;

    final auth = context.read<AuthViewModel>();
    final ok = await auth.requestPasswordReset(email);
    if (!mounted) return;

    if (ok) {
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
    final auth = context.watch<AuthViewModel>();

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                Gap(h: 134),
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
                Text(
                  'Verify Your Account',
                  style: AppTextStyles.subtitle,
                ),
                Gap(h: 12),
                Text(
                  'Enter your email to receive a password reset code.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.center,
                ),
                Gap(h: 48),
                GradientTextField(
                  hint: 'Enter your email',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                ),
                Gap(h: 48),
                GradientButton(
                  text: 'Continue',
                  enabled: !auth.isLoading,
                  onTap: _continue,
                ),
                Gap(h: 29),
                Text(
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