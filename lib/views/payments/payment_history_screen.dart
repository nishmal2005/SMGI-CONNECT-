import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_sizes.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/data/models/payment_model.dart';
import 'package:smgi.connect/viewmodels/payment_viewmodel.dart';

import '../../widgets/app_bar.dart';
import '../../widgets/app_scaffold.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentViewModel>().loadHistory();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PaymentViewModel>();
    final visible = vm.filtered;

    return AppScaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HomeAppBar(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.padding,
                  vertical: AppSizes.padding,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSizes.radius),
                        border: Border.all(
                          color: const Color(0xFFE4E4E4),
                          width: 0.75.w,
                        ),
                        color: Colors.white,
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: vm.setQuery,
                        style: AppTextStyles.inputText,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: AppTextStyles.inputHint,
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.gray,
                            size: 20.r,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Expanded(child: _buildBody(vm, visible)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(PaymentViewModel vm, List<PaymentModel> visible) {
    if (vm.isLoading && vm.payments.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.errorMessage != null && vm.payments.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.paddingLarge,
            vertical: 48.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 36.r, color: AppColors.error),
              SizedBox(height: 12.h),
              Text(
                _truncate(vm.errorMessage!, 260),
                textAlign: TextAlign.center,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body2.copyWith(color: AppColors.error),
              ),
              SizedBox(height: 12.h),
              TextButton(onPressed: vm.loadHistory, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }
    if (visible.isEmpty) {
      return Center(
        child: Text(
          vm.query.isEmpty ? 'No payments yet.' : 'No results found.',
          style: AppTextStyles.body2.copyWith(color: AppColors.gray),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: vm.loadHistory,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: visible.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: AppColors.lightGray,
          indent: 16.w,
          endIndent: 16.w,
        ),
        itemBuilder: (_, i) {
          final item = visible[i];
          return Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: PaymentCardWidget(item: item),
          );
        },
      ),
    );
  }

  String _truncate(String v, int max) =>
      v.length <= max ? v : '${v.substring(0, max)}…';
}

class PaymentCardWidget extends StatelessWidget {
  final PaymentModel item;
  const PaymentCardWidget({super.key, required this.item});

  Color get _statusColor {
    switch (item.status.toLowerCase()) {
      case 'success':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'failed':
        return AppColors.error;
      default:
        return AppColors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42.r,
          height: 42.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF070D19), Color(0xFF0085FF)],
            ),
          ),
          child: Container(
            margin: EdgeInsets.all(2.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.r),
              child: Image.asset(
                'assets/images/cardicon.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: AppTextStyles.body2.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(item.dateTimeLabel, style: AppTextStyles.condition),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              item.amount,
              style: AppTextStyles.body3.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              item.status,
              style: TextStyle(
                color: _statusColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
