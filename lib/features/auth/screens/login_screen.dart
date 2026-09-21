import 'package:flutter/material.dart';
//import 'package:http/http.dart';
import 'package:smgi.connect/features/auth/provider/auth_provider.dart';
import 'package:smgi.connect/features/auth/screens/otp_screen.dart';
import '../../../shared/widgets/auth/auth_background.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/gap.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/auth/gradient_text_field.dart';
import '../../../core/constants/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController inputController = TextEditingController();
  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flow = context.watch<AuthProvider>().flow;
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
                Text(
                  flow == AuthFlow.register
                      ? 'Login to continue'
                      : 'Verify your account',
                  style: AppTextStyles.subtitle,
                ),
                const Gap(h: 80),

                /// CONNECTED FIELD ✅
                GradientTextField(
                  hint: 'Enter your email',
                  controller: inputController,
                ),
                const Gap(h: 80),
                GradientButton(
                  text: 'Continue',
                  onTap: () {
                    final input = inputController.text.trim();
                    if (input.isEmpty) return;
                    final auth = context.read<AuthProvider>();
                    final request = flow == AuthFlow.forgotPassword
                        ? auth.requestPasswordReset(input)
                        : auth.sendOtp(input);

                    request.then((success) {
                      if (success && context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OtpScreen(input: input),
                          ),
                        );
                      } else if (!success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              auth.errorMessage ?? 'Unable to send OTP.',
                            ),
                          ),
                        );
                      }
                    });
                  },
                ),

                const Gap(h: 29),

                const Text(
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
