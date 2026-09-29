import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_sizes.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/viewmodels/application_viewmodel.dart';
import 'package:smgi.connect/viewmodels/referral_viewmodel.dart';


import '../../widgets/gap.dart';
import '../../widgets/gradient_button.dart';
import 'review_details_screen.dart';

class ApplyReferralScreen extends StatefulWidget {
  const ApplyReferralScreen({super.key});

  @override
  State<ApplyReferralScreen> createState() => _ApplyReferralScreenState();
}

class _ApplyReferralScreenState extends State<ApplyReferralScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onApply() async {
    final vm = context.read<ReferralViewModel>();
    final app = context.read<ApplicationViewModel>();

    final code = _controller.text.trim();
    if (code.isEmpty) {
      _snack('Enter a referral code first.');
      return;
    }

    // The backend requires an application_id when applying a referral.
    final appId = int.tryParse(app.applicationId ?? '');
    if (appId == null) {
      _snack(
        'Application not created yet. Complete the earlier steps first.',
      );
      return;
    }

    // 1) Validate — preview referrer details.
    final okPreview = await vm.validate(code);
    if (!mounted) return;
    if (!okPreview) {
      _snack(vm.errorMessage ?? 'Invalid referral code.');
      return;
    }

    // 2) Apply — carries the application id the backend expects.
    final okApply = await vm.apply(code: code, applicationId: appId);
    if (!mounted) return;
    if (!okApply) {
      _snack(vm.errorMessage ?? 'Could not apply referral code.');
      return;
    }

    // 3) Propagate to the aggregate application state so the
    //    Review screen can display it.
    app.setReferralCode(code);
  }

  void _onRemove() {
    _controller.clear();
    context.read<ReferralViewModel>().clearApplied();
    context.read<ApplicationViewModel>().setReferralCode(null);
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReferralViewModel>();

    return Scaffold(
      backgroundColor: AppColors.white,

      // ── Bottom info box ─────────────────────────
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 24.r,
                  width: 24.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFF56A3F4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_outline,
                    size: 14.r,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    'Referral code can be applied by mediators including '
                    'faculty, students, or others who assist with admissions.',
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFF777777),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Back ────────────────────────────
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.accent,
                  size: 22.r,
                ),
                onPressed: () => Navigator.pop(context),
              ),

              // ── Title ───────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Apply Referral Code',
                  style: AppTextStyles.pageTitle,
                ),
              ),

              SizedBox(height: 16.h),

              // ── Yellow banner ───────────────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
                color: AppColors.accent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apply your referral code.',
                      style: AppTextStyles.captionone,
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        // ── Pill input ────────────
                        Expanded(
                          child: Container(
                            height: 48.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 14.w),
                                Icon(
                                  Icons.local_offer_outlined,
                                  size: 18.r,
                                  color: const Color(0xFFE73CBC),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    enabled: !vm.isApplying,
                                    style: AppTextStyles.fieldTitle,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    decoration: InputDecoration(
                                      hintText: 'Enter your referral code',
                                      hintStyle: AppTextStyles.inputHint,
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),

                        // ── Apply button ──────────
                        SizedBox(
                          height: 48.h,
                          width: 88.w,
                          child: GradientButton(
                            text: vm.isApplying ? '...' : 'Apply',
                            enabled: !vm.isApplying,
                            onTap: _onApply,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Animated reveal ─────────────────
              AnimatedSize(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      axisAlignment: -1,
                      child: child,
                    ),
                  ),
                  child: vm.hasApplied
                      ? _buildReferrerDetailsSection(vm)
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReferrerDetailsSection(ReferralViewModel vm) {
    final r = vm.appliedReferral;
    if (r == null) return const SizedBox.shrink();

    return Padding(
      key: const ValueKey('referrer_details'),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Applied-code chip ────────────────
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3FBF5),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFBFE8C6)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_offer_outlined,
                      size: 16.r,
                      color: const Color(0xFFE73CBC),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      r.referralCode,
                      style: AppTextStyles.fieldTitle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: _onRemove,
                      child: Icon(
                        Icons.close,
                        size: 16.r,
                        color: const Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // ── Success line ─────────────────────
          Row(
            children: [
              Container(
                height: 18.r,
                width: 18.r,
                decoration: const BoxDecoration(
                  color: Color(0xFF3DBE6C),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 12.r,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Referral Code Applied Successfully',
                style: AppTextStyles.caption.copyWith(
                  color: const Color(0xFF3DBE6C),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // ── Referrer details ─────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FC),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE2E8F5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'REFERRER DETAILS',
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF1656C9),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                SizedBox(height: 12.h),
                _detailRow('Name :', r.referrerName),
                SizedBox(height: 8.h),
                _detailRow('Mobile :', r.referrerMobile),
                SizedBox(height: 8.h),
                _detailRow('State :', r.referrerState),
                SizedBox(height: 12.h),
                Text(
                  '"Mediator details shown for verification"',
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF999999),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // ── Continue ─────────────────────────
          SizedBox(
            width: double.infinity,
            height: AppSizes.buttonHeight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radius),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF0B1E3D), Color(0xFF1656C9)],
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppSizes.radius),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ReviewDetailsScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: AppTextStyles.fieldTitle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.arrow_forward,
                        size: 18.r,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 64.w,
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: const Color(0xFF777777),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.fieldTitle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}