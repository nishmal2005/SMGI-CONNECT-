import 'package:flutter/material.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/features/refferaldetails/review_details.dart';

import 'package:smgi.connect/shared/widgets/gradient_button.dart';

class ApplyReferralPage extends StatefulWidget {
  ApplyReferralPage({super.key});

  @override
  State<ApplyReferralPage> createState() => _ApplyReferralPageState();
}

class _ApplyReferralPageState extends State<ApplyReferralPage> {
  final TextEditingController referralController = TextEditingController();

  bool _isReferralApplied = false;

  /// Mock referrer details shown once a code is applied.
  final String _appliedCode = 'SMGI2025REF89';
  final String _referrerName = 'Akhil P. (ID: RF12873)';
  final String _referrerMobile = '+91 9876534232';
  final String _referrerState = 'Kerala';

  void _applyReferralCode() {
    setState(() {
      _isReferralApplied = true;
    });
  }

  void _removeReferralCode() {
    setState(() {
      _isReferralApplied = false;
      referralController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      /// Bottom info box
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                width: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFF56A3F4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.info_outline,
                  size: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Referral code can be applied by mediators including faculty, students, or others who assist with admissions.',
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF777777),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Back button
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () => Navigator.pop(context),
              ),

              /// Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Apply Referral Code',
                  style: AppTextStyles.pageTitle,
                ),
              ),

              const SizedBox(height: 16),

              /// Yellow banner (FULL WIDTH)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                color: const Color(0xFFDAA520),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Caption
                    Text(
                      'Apply your referral code.',
                      style: AppTextStyles.captionone,
                    ),

                    const SizedBox(height: 14),

                    /// Input + Apply button
                    Row(
                      children: [
                        /// Input field (pill)
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 14),
                                Icon(
                                  Icons.local_offer_outlined,
                                  size: 18,
                                  color: const Color(0xFFE73CBC),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: referralController,
                                    style: AppTextStyles.fieldTitle,
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

                        const SizedBox(width: 12),

                        /// Apply button (same height)
                        SizedBox(
                          height: 48,
                          width: 88,
                          child: GradientButton(
                            text: 'Apply',
                            onTap: _applyReferralCode,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// Animated referrer-details reveal
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
                  child: _isReferralApplied
                      ? _buildReferrerDetailsSection()
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Applied-code chip + referrer details card + continue button
  Widget _buildReferrerDetailsSection() {
    return Padding(
      key: const ValueKey('referrer_details'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Applied code chip
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3FBF5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFBFE8C6)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_offer_outlined,
                      size: 16,
                      color: const Color(0xFFE73CBC),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _appliedCode,
                      style: AppTextStyles.fieldTitle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _removeReferralCode,
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Success line
          Row(
            children: [
              Container(
                height: 18,
                width: 18,
                decoration: const BoxDecoration(
                  color: Color(0xFF3DBE6C),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 12, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Text(
                'Referral Code Applied Successfully',
                style: AppTextStyles.caption.copyWith(
                  color: const Color(0xFF3DBE6C),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Referrer details card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FC),
              borderRadius: BorderRadius.circular(12),
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
                const SizedBox(height: 12),
                _buildDetailRow('Name :', _referrerName),
                const SizedBox(height: 8),
                _buildDetailRow('Mobile :', _referrerMobile),
                const SizedBox(height: 8),
                _buildDetailRow('State :', _referrerState),
                const SizedBox(height: 12),
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

          const SizedBox(height: 20),

          /// Continue button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF0B1E3D), Color(0xFF1656C9)],
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
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
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward,
                        size: 18,
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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 64,
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
