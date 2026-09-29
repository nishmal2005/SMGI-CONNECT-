import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/gradient_button.dart';
import 'payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // ── Config ──────────────────────────────────────
  static const int _amountInPaise = 500000; // ₹5,000
  static const String _razorpayKey = 'rzp_test_Tcbw1632JIWy2B';
  static const String _merchantName = 'Shri Maruthi Group';
  static const String _description = 'Admission Fee';

  final Razorpay _razorpay = Razorpay();
  bool _opening = false;

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  /// Optional server-side order id. Return `null` to skip.
  Future<String?> _createOrderOnServer(int amountInPaise) async => null;

  Future<void> _openCheckout() async {
    setState(() => _opening = true);

    final orderId = await _createOrderOnServer(_amountInPaise);

    final options = <String, dynamic>{
      'key': _razorpayKey,
      'amount': _amountInPaise,
      'name': _merchantName,
      'description': _description,
      if (orderId != null) 'order_id': orderId,
      'prefill': {
        'contact': '9999999999',
        'email': 'test@example.com',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay error: $e');
      if (mounted) setState(() => _opening = false);
      _snack('Unable to open payment checkout.');
    }
  }

  void _onSuccess(PaymentSuccessResponse response) {
    if (!mounted) return;
    setState(() => _opening = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>PaymentSuccessScreen (
          paymentId: response.paymentId,
          orderId: response.orderId,
        ),
      ),
    );
  }

  void _onError(PaymentFailureResponse response) {
    if (mounted) setState(() => _opening = false);
    _snack(response.message ?? 'Payment was not completed.');
  }

  void _onWallet(ExternalWalletResponse response) {
    if (mounted) setState(() => _opening = false);
    _snack('External wallet selected: ${response.walletName ?? 'wallet'}');
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.pop(context),
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
              _feeCard(),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  text: 'Continue to Payment',
                  enabled: !_opening,
                  onTap: _opening ? null : _openCheckout,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _feeCard() {
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
                'Admission Fee:',
                style: AppTextStyles.body3.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          Text(
            '₹5,000',
            style: AppTextStyles.body3.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}