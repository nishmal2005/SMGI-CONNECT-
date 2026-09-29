import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/viewmodels/auth_viewmodel.dart';




import '../../widgets/auth_background.dart';
import '../../widgets/gap.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/otp_box.dart';
import 'password_creation_screen.dart';
import 'reset_password_screen.dart';

class OtpScreen extends StatefulWidget {
  final String input;

  const OtpScreen({super.key, required this.input});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _controllers = List.generate(4, (_) => TextEditingController());
  final _focus = List.generate(4, (_) => FocusNode());

  String get _entered => _controllers.map((c) => c.text).join();

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focus) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> _verify() async {
    if (_entered.length != 4) return;

    final auth = context.read<AuthViewModel>();
    final ok = await auth.verifyOtp(widget.input, _entered);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Invalid OTP.')),
      );
      return;
    }

    final isForgot = auth.flow == AuthFlow.forgotPassword;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => isForgot
            ? const ResetPasswordScreen()
            : const PasswordCreationScreen(),
      ),
    );
  }

  Future<void> _resend() async {
    final auth = context.read<AuthViewModel>();
    final ok = auth.flow == AuthFlow.forgotPassword
        ? await auth.requestPasswordReset(widget.input)
        : await auth.sendOtp(widget.input);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Unable to resend.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final minutes = (vm.secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (vm.secondsLeft % 60).toString().padLeft(2, '0');

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                Gap(h: 84),
                Text(
                  'Enter OTP',
                  style: AppTextStyles.subtitle,
                  textAlign: TextAlign.center,
                ),
                Gap(h: 8),
                Text(
                  'A 4-digit code has been sent to your\nregistered email.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.center,
                ),
                Gap(h: 37),

                // ── OTP boxes ──────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (i) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7.w),
                      child: OtpBox(
                        controller: _controllers[i],
                        focusNode: _focus[i],
                        onChanged: (value) {
                          if (value.isNotEmpty && i < 3) {
                            _focus[i + 1].requestFocus();
                          }
                          if (value.isEmpty && i > 0) {
                            _focus[i - 1].requestFocus();
                          }
                          setState(() {}); // refresh button enabled state
                        },
                      ),
                    );
                  }),
                ),
                Gap(h: 24),

                // ── Timer ──────────────────────────────
                if (vm.secondsLeft > 0)
                  Text('$minutes:$seconds', style: AppTextStyles.caption),
                Gap(h: 13),

                // ── Resend ─────────────────────────────
                GestureDetector(
                  onTap: vm.secondsLeft == 0 ? _resend : null,
                  child: Text(
                    'Resend OTP',
                    style: AppTextStyles.caption.copyWith(
                      color: vm.secondsLeft == 0
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ),
                ),
                Gap(h: 50),

                // ── Verify ─────────────────────────────
                GradientButton(
                  text: 'Verify Code',
                  enabled: _entered.length == 4 && !vm.isLoading,
                  onTap: _verify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}