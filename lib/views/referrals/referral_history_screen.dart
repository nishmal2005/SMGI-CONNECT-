import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_sizes.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/data/models/referral_model.dart';
import 'package:smgi.connect/viewmodels/referral_viewmodel.dart';

import '../../widgets/app_bar.dart';
import '../../widgets/app_scaffold.dart';

class ReferralHistoryScreen extends StatefulWidget {
  const ReferralHistoryScreen({super.key});

  @override
  State<ReferralHistoryScreen> createState() => _ReferralHistoryScreenState();
}

class _ReferralHistoryScreenState extends State<ReferralHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReferralViewModel>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReferralViewModel>();

    return AppScaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeAppBar(),

            // ── Title ──────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSizes.padding,
                12.h,
                AppSizes.padding,
                16.h,
              ),
              child: Text(
                'Referral Code',
                style: AppTextStyles.pageTitle.copyWith(
                  fontSize: 22.sp,
                  color: Colors.black87,
                ),
              ),
            ),

            // ── Body ───────────────────────────────
            Expanded(child: _buildBody(vm)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(ReferralViewModel vm) {
    if (vm.isLoading && vm.history.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.errorMessage != null && vm.history.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.paddingLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                vm.errorMessage!,
                textAlign: TextAlign.center,
                style: AppTextStyles.body2.copyWith(color: AppColors.error),
              ),
              SizedBox(height: 12.h),
              TextButton(onPressed: vm.loadHistory, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }
    if (vm.history.isEmpty) {
      return Center(
        child: Text(
          'No referral codes yet.',
          style: AppTextStyles.body2.copyWith(color: AppColors.gray),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: vm.loadHistory,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.padding,
          vertical: 8.h,
        ),
        itemCount: vm.history.length,
        itemBuilder: (_, i) => _ReferralCard(referral: vm.history[i]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Card
// ─────────────────────────────────────────────────────

class _ReferralCard extends StatelessWidget {
  final ReferralModel referral;
  const _ReferralCard({required this.referral});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(Icons.qr_code_2, size: 32.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1 Referral Code',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      referral.referralCode,
                      style: TextStyle(fontSize: 13.sp, color: Colors.black45),
                    ),
                  ],
                ),
              ),
              _StatusBadge(status: referral.status),
            ],
          ),
          SizedBox(height: 14.h),
          _infoRow('Course:', referral.course),
          SizedBox(height: 6.h),
          _infoRow('Referred By:', referral.referrerName),
          SizedBox(height: 14.h),
          const Divider(height: 1),
          SizedBox(height: 14.h),
          _ReferrerDetailsBox(referral: referral),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 13.sp, color: Colors.black45),
        children: [
          TextSpan(text: '$label '),
          TextSpan(
            text: value,
            style: const TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isApplied = status.toLowerCase() == 'applied';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          status,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isApplied ? const Color(0xFF34A853) : Colors.black54,
          ),
        ),
        SizedBox(width: 4.w),
        if (isApplied)
          Icon(Icons.check_circle, color: const Color(0xFF34A853), size: 16.r),
      ],
    );
  }
}

class _ReferrerDetailsBox extends StatelessWidget {
  final ReferralModel referral;
  const _ReferrerDetailsBox({required this.referral});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FE),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'REFERRER DETAILS',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF3366CC),
              letterSpacing: 0.4,
            ),
          ),
          SizedBox(height: 10.h),
          _detailRow(
            'Name :',
            '${referral.referrerName} '
                '(ID: ${referral.referrerId})',
          ),
          SizedBox(height: 6.h),
          _detailRow('Mobile :', referral.referrerMobile),
          SizedBox(height: 6.h),
          _detailRow('State :', referral.referrerState),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70.w,
          child: Text(
            label,
            style: TextStyle(fontSize: 13.sp, color: Colors.black45),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
