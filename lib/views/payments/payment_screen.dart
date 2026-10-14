

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hypersdkflutter/hypersdkflutter.dart';
import 'package:provider/provider.dart';
import 'package:smgi_connect/viewmodels/payment_viewmodel.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/payment_model.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/gradient_button.dart';
import 'payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String applicationId;

  const PaymentScreen({super.key, required this.applicationId});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final HyperSDK _hyperSDK = HyperSDK();
  bool _opening = false;
  bool _sdkCheckoutOpen = false;
  bool _handlingResult = false;
  bool _verificationStarted = false;
  String? _activeOrderId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentViewModel>().loadSummary(widget.applicationId);
    });
  }

  @override
  void dispose() {
    _hyperSDK.dispose();
    super.dispose();
  }

  Future<void> _openCheckout() async {
    final vm = context.read<PaymentViewModel>();
    setState(() => _opening = true);
    _verificationStarted = false;
    _activeOrderId = null;

    final checkout = await vm.startCheckout(widget.applicationId);
    if (!mounted) return;
    if (checkout == null) {
      setState(() => _opening = false);
      _snack(vm.flowError ?? 'Unable to initiate payment.');
      return;
    }
    _activeOrderId = checkout.orderId;

    if (checkout.alreadyPaid) {
      await vm.loadSummary(widget.applicationId);
      if (mounted) setState(() => _opening = false);
      return;
    }

    try {
      if (!await _hyperSDK.isInitialised()) {
        await _hyperSDK.initiate(
          checkout.sdkInitPayload!,
          _onInitiateCallback,
        );
        if (!await _hyperSDK.isInitialised()) {
          throw StateError(
            'HyperSDK did not initialize. Check the payment client ID and native SDK configuration.',
          );
        }
      }
      if (!mounted) return;
      _sdkCheckoutOpen = true;
      await _hyperSDK.process(
        checkout.sdkPayload!,
        _onHyperSDKCallback,
      );
    } on PlatformException catch (e) {
      _sdkCheckoutOpen = false;
      if (mounted) setState(() => _opening = false);
      vm.markFailure(e.message ?? 'HyperSDK could not open payment checkout.');
      _snack(vm.flowError!);
    } on MissingPluginException {
      _sdkCheckoutOpen = false;
      if (mounted) setState(() => _opening = false);
      vm.markFailure('HyperSDK is not available in this app build.');
      _snack(vm.flowError!);
    } on StateError catch (e) {
      _sdkCheckoutOpen = false;
      if (mounted) setState(() => _opening = false);
      vm.markFailure(e.message);
      _snack(vm.flowError!);
    } on Exception catch (e) {
      _sdkCheckoutOpen = false;
      if (mounted) setState(() => _opening = false);
      vm.markFailure('Unable to open payment checkout: $e');
      _snack(vm.flowError!);
    }
  }

  void _onInitiateCallback(MethodCall call) {
    if (call.method == 'initiate_result') {
      debugPrint('HyperSDK initialization callback received.');
    }
  }

  Future<void> _onHyperSDKCallback(MethodCall call) async {
    if (call.method != 'process_result' ||
        _handlingResult ||
        _verificationStarted) {
      return;
    }
    if (!mounted) return;
    _handlingResult = true;
    _sdkCheckoutOpen = false;

    final vm = context.read<PaymentViewModel>();
    try {
      debugPrint(
        'HyperSDK process result received; verifying the order with the backend.',
      );

      final orderId = _activeOrderId;
      if (orderId == null || orderId.isEmpty) {
        vm.markFailure(
          'Unable to verify payment because the checkout order ID is missing.',
        );
        if (mounted) {
          setState(() => _opening = false);
          _snack(vm.flowError!);
        }
        return;
      }

      _verificationStarted = true;
      final verified = await vm.verifyPayment(widget.applicationId, orderId);
      if (!mounted) return;
      setState(() => _opening = false);

      if (verified) {
        final details = vm.successDetails;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentSuccessScreen(
              paymentId: details?.paymentId,
              orderId: details?.orderId,
              paymentMethod: details?.method,
            ),
          ),
        );
      } else {
        _snack(vm.flowError ?? 'Payment verification failed.');
      }
    } finally {
      _handlingResult = false;
    }
  }

  Future<bool> _handleBackNavigation() async {
    if (_handlingResult) return false;
    if (defaultTargetPlatform == TargetPlatform.android && _sdkCheckoutOpen) {
      final result = await _hyperSDK.onBackPress();
      if (result.toLowerCase() == 'true') return false;
    }
    return true;
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PaymentViewModel>();
    final summary = vm.summary;

    return WillPopScope(
      onWillPop: _handleBackNavigation,
      child: AppScaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () async {
                    if (await _handleBackNavigation() && mounted) {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.accent,
                    size: 22.r,
                  ),
                ),
                SizedBox(height: 28.h),
                Text(
                  'Payments',
                  style: AppTextStyles.pageTitle.copyWith(fontSize: 20.sp),
                ),
                SizedBox(height: 22.h),
                if (vm.state == PaymentFlowState.loadingSummary)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (vm.state == PaymentFlowState.failure &&
                    summary == null)
                  _errorCard(vm.flowError ?? 'Unable to load payment details.')
                else if (summary != null)
                  _feeCard(summary),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    text: summary?.isPaid == true
                        ? 'Already Paid'
                        : 'Continue to Payment',
                    enabled: !_opening &&
                        summary != null &&
                        summary.canPay &&
                        !summary.isPaid,
                    onTap: (_opening ||
                            summary == null ||
                            !summary.canPay ||
                            summary.isPaid)
                        ? null
                        : _openCheckout,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _feeCard(PaymentSummaryModel summary) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.18),
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MINIMUM PAYMENT REQUIRED',
                style: AppTextStyles.inputHint.copyWith(fontSize: 11.sp),
              ),
              SizedBox(height: 6.h),
              Text(
                '${summary.title}:',
                style: AppTextStyles.body3.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          Text(
            '₹${summary.amount.toStringAsFixed(0)}',
            style: AppTextStyles.body3.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorCard(String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 20.r),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.body3.copyWith(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () => context
                .read<PaymentViewModel>()
                .loadSummary(widget.applicationId),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}