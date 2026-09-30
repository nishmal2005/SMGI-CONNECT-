import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_text_styles.dart';
import '../../widgets/gap.dart';
import '../downloads/downloads_screen.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String? paymentId;
  final String? orderId;
  final String? paymentMethod;

  const PaymentSuccessScreen({
    super.key,
    this.paymentId,
    this.orderId,
    this.paymentMethod,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), _goToDownloads);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _goToDownloads() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DownloadsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/Payment Success.png',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/success.png',
                      width: 60.r,
                      height: 60.r,
                    ),
                    Gap(h: 16),
                    Text(
                      'Payment Successful',
                      style: AppTextStyles.headline,
                      textAlign: TextAlign.center,
                    ),
                    Gap(h: 4),
                    Text(
                      'to Shri Maruthi Group',
                      style: AppTextStyles.captionone,
                      textAlign: TextAlign.center,
                    ),
                    Gap(h: 20),
                    Text(
                      _formatNow(),
                      style: AppTextStyles.captionone,
                    ),
                    if (widget.paymentMethod != null &&
                        widget.paymentMethod!.isNotEmpty) ...[
                      Gap(h: 12),
                      Text(
                        'Payment Method: ${widget.paymentMethod}',
                        style: AppTextStyles.captionone,
                        textAlign: TextAlign.center,
                      ),
                    ],
                    if (widget.paymentId != null) ...[
                      Gap(h: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              'Payment ID: ${widget.paymentId}',
                              style: AppTextStyles.captionone,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Gap(w: 6),
                          Icon(
                            Icons.copy,
                            size: 16.r,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ],
                    if (widget.orderId != null) ...[
                      Gap(h: 4),
                      Text(
                        'Order ID: ${widget.orderId}',
                        style: AppTextStyles.captionone,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNow() {
    final now = DateTime.now();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final h = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final ampm = now.hour < 12 ? 'am' : 'pm';
    final m = now.minute.toString().padLeft(2, '0');
    return '${now.day} ${months[now.month - 1]} ${now.year} '
        '$h:$m $ampm';
  }
}