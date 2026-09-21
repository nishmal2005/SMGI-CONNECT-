import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/features/paymentsuccess/success_screen.dart';
import 'package:smgi.connect/shared/widgets/app_scaffold.dart';
import 'package:smgi.connect/shared/widgets/gradient_button.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const int _amountInPaise = 500000;
  static const String _razorpayKey = 'rzp_test_Tcbw1632JIWy2B';

  final Razorpay _razorpay = Razorpay();
  bool _isOpeningCheckout = false;

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<String?> _createOrderOnServer(int amountInPaise) async => null;

  Future<void> _openCheckout() async {
    setState(() => _isOpeningCheckout = true);
    final orderId = await _createOrderOnServer(_amountInPaise);
    final options = <String, dynamic>{
      'key': _razorpayKey,
      'amount': _amountInPaise,
      'name': 'Shri Maruthi group',
      'description': 'Admission Fee',
      if (orderId != null) 'order_id': orderId,
      'prefill': {'contact': '9999999999', 'email': 'test@example.com'},
    };
    try {
      _razorpay.open(options);
    } catch (error) {
      _showMessage('Unable to open payment checkout.');
      debugPrint('Razorpay error: $error');
      if (mounted) setState(() => _isOpeningCheckout = false);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (!mounted) return;
    setState(() => _isOpeningCheckout = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PaymentSuccessScreen()),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (mounted) setState(() => _isOpeningCheckout = false);
    _showMessage(response.message ?? 'Payment was not completed.');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (mounted) setState(() => _isOpeningCheckout = false);
    _showMessage(
      'External wallet selected: ${response.walletName ?? 'wallet'}',
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: AppColors.accent),
            ),
            const SizedBox(height: 28),
            Text(
              'Payments',
              style: AppTextStyles.pageTitle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 22),
            _buildFeeCard(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                text: 'Continue to Payment',
                enabled: !_isOpeningCheckout,
                onTap: _isOpeningCheckout ? null : _openCheckout,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MINIMUM PAYMENT REQUIRED',
                style: AppTextStyles.inputHint.copyWith(fontSize: 11),
              ),
              const SizedBox(height: 6),
              Text(
                'Admission Fee:',
                style: AppTextStyles.body3.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            '₹5,000',
            style: AppTextStyles.body3.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}