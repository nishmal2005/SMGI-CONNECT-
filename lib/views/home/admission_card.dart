import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../viewmodels/application_viewmodel.dart';
import '../../widgets/gap.dart';
import '../../widgets/gradient_button.dart';
import '../admission/aadhaar_verification_screen.dart';
import '../admission/application_status_screen.dart';
import '../admission/course_selection_screen.dart';
import '../admission/personal_details_screen.dart';
import '../admission/upload_marks_card_screen.dart';
import '../referrals/apply_referral_screen.dart';

class AdmissionCard extends StatelessWidget {
  /// Which stage of the admission flow the user is at.
  final AdmissionState state;

  const AdmissionCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ApplicationViewModel>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFF8FAFF)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Gap(h: 15),
          Image.asset(
            'assets/images/cardicon.png',
            width: 90.r,
            height: 90.r,
          ),
          const Gap(h: 16),

          // ── Title ───────────────────────────────────
          Text(
            _title(),
            style: AppTextStyles.subtitle.copyWith(
              fontSize: 18.sp,
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(h: 8),

          // ── Subtitle ────────────────────────────────
          Text(
            _subtitle(),
            style: AppTextStyles.condition.copyWith(
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(h: 20),

          // ── CTA ─────────────────────────────────────
          if (state == AdmissionState.completed)
            const _CompletedBadge()
          else
            GradientButton(
              text: state == AdmissionState.notStarted
                  ? 'Start Now →'
                  : 'Continue →',
              onTap: () => _onTap(context, vm),
            ),
        ],
      ),
    );
  }

  // ── Text per state ────────────────────────────────
  String _title() => switch (state) {
        AdmissionState.notStarted => 'Start Admission Process',
        AdmissionState.inProgress => 'Continue Admission',
        AdmissionState.completed  => 'Admission Submitted',
      };

  String _subtitle() => switch (state) {
        AdmissionState.notStarted =>
          'Complete your Aadhaar, course selection & '
          'payment in one flow.',
        AdmissionState.inProgress =>
          'You have already started. Resume from where '
          'you left off.',
        AdmissionState.completed =>
          'Your application is with the admission team. '
          'You can track the status from My Account.',
      };

  // ── Navigation per state ──────────────────────────
  void _onTap(BuildContext context, ApplicationViewModel vm) {
    if (state == AdmissionState.notStarted) {
      _push(context, const AadhaarVerificationScreen());
      return;
    }
    // inProgress → resume at the first incomplete step
    switch (vm.resumeStep) {
      case 'aadhaar':
        _push(context, const AadhaarVerificationScreen());
      case 'personal':
        _push(context, const PersonalDetailsScreen());
      case 'course':
        _push(context, const CourseSelectionScreen());
      case 'marks':
        _push(context, const UploadMarksCardScreen());
      case 'referral':
        _push(context, const ApplyReferralScreen());
      case 'payment':
      default:
        // Replace with your payment summary screen if you have one.
        _push(context, const ApplicationStatusScreen());
    }
  }

  void _push(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

// ─────────────────────────────────────────────────────
// Static green "Completed" box — not tappable
// (unchanged from your original)
// ─────────────────────────────────────────────────────

class _CompletedBadge extends StatelessWidget {
  const _CompletedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52.h,
      decoration: BoxDecoration(
        color: AppColors.success, // #2ECC71 green
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            size: 20.r,
            color: Colors.white,
          ),
          const Gap(w: 8),
          Text(
            'Completed',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}