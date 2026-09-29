import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/viewmodels/application_viewmodel.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/leave_confirmation_dialog.dart';
import '../payments/payment_screen.dart';

class ReviewDetailsScreen extends StatefulWidget {
  const ReviewDetailsScreen({super.key});

  @override
  State<ReviewDetailsScreen> createState() => _ReviewDetailsScreenState();
}

class _ReviewDetailsScreenState extends State<ReviewDetailsScreen> {
  bool _confirmed = false;

  void _continue() {
    // Application already created in UploadMarksCardScreen.
    // Nothing to submit here — just move to payment.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PaymentScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<ApplicationViewModel>();
    final personal = app.personal;

    return AppScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 16.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => LeaveConfirmationDialog(
                      onLeave: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.accent,
                  size: 22.r,
                ),
              ),
              SizedBox(height: 8.h),

              _ReviewCard(
                title: 'Personal Information',
                data: {
                  'Name': (personal['name'] ?? '—').toString(),
                  'Gender': (personal['gender'] ?? '—').toString(),
                  'Email': (personal['email'] ?? '—').toString(),
                  'Mobile': (personal['phone1'] ?? '—').toString(),
                },
              ),
              SizedBox(height: 8.h),

              _ReviewCard(
                title: 'Course Selected',
                data: {
                  'Discipline': app.discipline ?? '—',
                  'Program': app.program ?? '—',
                },
              ),
              SizedBox(height: 8.h),

              _ReviewCard(
                title: 'Required Documents',
                data: {
                  'Aadhaar Card': (app.aadhaarFrontPath != null &&
                          app.aadhaarBackPath != null)
                      ? 'Uploaded'
                      : 'Pending',
                  '10th Marks Card':
                      app.marksCardPath != null ? 'Uploaded' : 'Pending',
                },
              ),
              SizedBox(height: 8.h),

              _ReviewCard(
                title: 'Referral Code',
                data: {
                  'Referral': app.referralCode ?? '—',
                },
              ),
              SizedBox(height: 24.h),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () =>
                        setState(() => _confirmed = !_confirmed),
                    child: Container(
                      width: 20.r,
                      height: 20.r,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(
                          color: const Color(0xFF9BA3B0),
                          width: 1.5.w,
                        ),
                      ),
                      child: _confirmed
                          ? Icon(
                              Icons.check,
                              size: 16.r,
                              color: AppColors.accent,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'I confirm that all the information provided above '
                      'is correct and complete to the best of my '
                      'knowledge and belief.',
                      style: AppTextStyles.body3.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              GradientButton(
                text: 'Continue',
                enabled: _confirmed,
                onTap: _continue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String title;
  final Map<String, String> data;

  const _ReviewCard({required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFE4E4E4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              Text(
                'Edit',
                style: TextStyle(
                  color: const Color(0xFF0086FF),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(height: 1, color: const Color(0xFFE4E4E4)),
          SizedBox(height: 20.h),
          ...data.entries.map((e) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${e.key}:',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.gray,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      e.value,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 6.h),
        ],
      ),
    );
  }
}