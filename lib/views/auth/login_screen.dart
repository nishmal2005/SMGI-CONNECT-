import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/viewmodels/auth_viewmodel.dart';
import 'package:smgi.connect/views/home/home_shell.dart';


import '../../widgets/gap.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/plain_text_field.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final auth = context.read<AuthViewModel>();
    final ok = await auth.login(_email.text.trim(), _password.text);
    if (!mounted) return;

    if (ok) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeShell()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Login failed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: _BannerClipper(),
                child: Image.asset(
                  'assets/images/banner.png',
                  width: double.infinity,
                  height: 220.h,
                  fit: BoxFit.cover,
                ),
              ),

              Gap(h: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.accent, AppColors.black],
                    ).createShader(bounds),
                    child: Text('SMGI', style: AppTextStyles.logoGold),
                  ),
                  Gap(w: 4),
                  Text('Connect', style: AppTextStyles.logoblack),
                ],
              ),

              Gap(h: 16),

              Container(
                width: 90.r,
                height: 90.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: AppColors.white, width: 2.w),
                ),
              ),

              Gap(h: 32),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    PlainTextField(
                      hint: 'Enter your email',
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    Gap(h: 16),
                    PlainTextField(
                      hint: 'Enter password',
                      controller: _password,
                      obscureText: true,
                    ),
                    Gap(h: 16),

                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          context
                              .read<AuthViewModel>()
                              .setFlow(AuthFlow.forgotPassword);
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
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primary,
                          ),
                        ),
                      ),
                    ),

                    Gap(h: 24),

                    GradientButton(
                      text: 'Login',
                      enabled: !auth.isLoading,
                      onTap: _login,
                    ),

                    Gap(h: 20),

                    GestureDetector(
                      onTap: () {
                        context
                            .read<AuthViewModel>()
                            .setFlow(AuthFlow.register);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black54,
                          ),
                          children: [
                            const TextSpan(
                              text: "Haven't registered yet? ",
                            ),
                            TextSpan(
                              text: 'Register now',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Gap(h: 24),
                  ],
                ),
              ),
            ],
          ),
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