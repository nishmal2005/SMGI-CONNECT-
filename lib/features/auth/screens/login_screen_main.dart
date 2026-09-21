import 'package:flutter/material.dart';
//import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
//import 'package:smgi.connect/features/aadhar/screens/aadhaar_verification_screen.dart';
import 'package:smgi.connect/features/auth/provider/auth_provider.dart';
import 'package:smgi.connect/features/auth/screens/forgot_password_screen.dart';
import 'package:smgi.connect/features/auth/screens/login_screen.dart';
import 'package:smgi.connect/features/navbar/home_bottom_nav.dart';
import 'package:smgi.connect/shared/widgets/gradient_button.dart';
import 'package:smgi.connect/shared/widgets/auth/plain_text_field.dart';
import 'package:smgi.connect/shared/widgets/gap.dart';

class LoginScreen2 extends StatelessWidget {
  const LoginScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner Image
            ClipPath(
              clipper: _BannerClipper(),
              child: Image.asset(
                'assets/images/banner.png',
                width: double.infinity,
                height: 260,
                fit: BoxFit.cover,
              ),
            ),

            const Gap(h: 24),

            // Logo text SMGI Connect
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.accent, AppColors.black],
                    ).createShader(bounds);
                  },
                  child: const Text('SMGI', style: AppTextStyles.logoGold),
                ),
                const Gap(w: 4),
                const Text('Connect', style: AppTextStyles.logoblack),
              ],
            ),

            const Gap(h: 16),

            // Circular Logo
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
                border: Border.all(color: AppColors.white, width: 2),
              ),
            ),

            const Gap(h: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  PlainTextField(
                    hint: 'Enter your email',
                    controller: emailController,
                  ),

                  const Gap(h: 16),

                  // Existing field 2
                  PlainTextField(
                    hint: 'Enter password',
                    obscureText: true,
                    controller: passwordController,
                  ),

                  const Gap(h: 16),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        context.read<AuthProvider>().setFlow(
                          AuthFlow.forgotPassword,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen(),
                          ),
                        );
                      },

                      child: Text(
                        'Forgotten password?',
                        style: AppTextStyles.caption.copyWith(
                          color: const Color(0xFF094B8A),
                          decoration: TextDecoration.underline,
                          decorationColor: const Color(0xFF094B8A),
                        ),
                      ),
                    ),
                  ),

                  const Gap(h: 24),

                  GradientButton(
                    text: 'Login',
                    onTap: () async {
                      final provider = context.read<AuthProvider>();
                      final success = await provider.login(
                        emailController.text.trim(),
                        passwordController.text,
                      );

                      if (!success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              provider.errorMessage ?? 'Login failed.',
                            ),
                          ),
                        );
                      }

                      if (success && context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => HomeBottomNav()),
                        );
                      }
                    },
                  ),

                  const Gap(h: 20),

                  GestureDetector(
                    onTap: () {
                      context.read<AuthProvider>().setFlow(AuthFlow.register);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                        children: [
                          TextSpan(text: "Haven't registered yet? "),
                          TextSpan(
                            text: 'Register now',
                            style: TextStyle(
                              color: Color(0xFF094B8A),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFF094B8A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Gap(h: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
