import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/features/auth/provider/auth_provider.dart';
import 'package:smgi.connect/features/auth/screens/passsword_creation_screen.dart';
import 'package:smgi.connect/features/auth/screens/reset_password_screen.dart';
import 'package:smgi.connect/features/auth/widgets/otp_box.dart';
import '../../../shared/widgets/auth/auth_background.dart';
import '../../../shared/widgets/gap.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../core/constants/app_text_styles.dart';

class OtpScreen extends StatefulWidget {
  final String input; // mobile/email

  const OtpScreen({super.key, required this.input});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _controllers = List.generate(4, (_) => TextEditingController());
  // final _c1 = TextEditingController();
  // final _c2 = TextEditingController();
  // final _c3 = TextEditingController();
  // final _c4 = TextEditingController();

  String get enteredOtp => _controllers.map((c) => c.text).join();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final secondsLeft = context.watch<AuthProvider>().secondsLeft;
    final minutes = (secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsLeft % 60).toString().padLeft(2, '0');

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.16),

                /// LOGO
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
                const Gap(h: 84),
                const Text(
                  'Enter OTP',
                  style: AppTextStyles.subtitle,
                  textAlign: TextAlign.center,
                ),
                const Gap(h: 8),
                const Text(
                  'A 4-digit code has been sent to your\nregistered email.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.center,
                ),
                const Gap(h: 37),

                /// OTP BOXES
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: OtpBox(
                        controller: _controllers[index],
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 3) {
                            FocusScope.of(context).nextFocus();
                          }
                          if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
                const Gap(h: 24),

                /// TIMER (2 minutes)
                if (secondsLeft > 0)
                  Text('$minutes:$seconds', style: AppTextStyles.caption),
                const Gap(h: 13),

                /// RESEND OTP
                GestureDetector(
                  onTap: secondsLeft == 0
                      ? () async {
                          final auth = context.read<AuthProvider>();
                          final success = auth.flow == AuthFlow.forgotPassword
                              ? await auth.resendOtp(widget.input)
                              : await auth.sendOtp(widget.input);
                          if (!success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  auth.errorMessage ?? 'Unable to resend OTP.',
                                ),
                              ),
                            );
                          }
                        }
                      : null,
                  child: Text(
                    'Resend OTP',
                    style: AppTextStyles.caption.copyWith(
                      color: secondsLeft == 0 ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
                const Gap(h: 50),

                /// VERIFY BUTTON
                GradientButton(
                  text: 'Verify Code',
                  onTap: () async {
                    if (enteredOtp.length != 4) return;

                    final success = await context
                        .read<AuthProvider>()
                        .verifyOtp(widget.input, enteredOtp);

                    if (success && context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              context.read<AuthProvider>().flow ==
                                  AuthFlow.forgotPassword
                              ? const ResetPasswordScreen()
                              : const PasswordCreationScreen(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
