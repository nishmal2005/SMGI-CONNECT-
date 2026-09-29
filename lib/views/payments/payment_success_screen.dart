import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';


class PaymentSuccessScreen extends StatelessWidget {
  final String? paymentId;
  final String? orderId;

  const PaymentSuccessScreen({
    super.key,
    this.paymentId,
    this.orderId,
  });

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
                    SizedBox(height: 16.h),
                    Text(
                      'Payment Successful',
                      style: AppTextStyles.headline,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'to Shri Maruthi Group',
                      style: AppTextStyles.captionone,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      _formatNow(),
                      style: AppTextStyles.captionone,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Payment Method: Axis Bank 5462',
                      style: AppTextStyles.captionone,
                    ),
                    if (paymentId != null) ...[
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              'Payment ID: $paymentId',
                              style: AppTextStyles.captionone,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(
                            Icons.copy,
                            size: 16.r,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ],
                    if (orderId != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        'Order ID: $orderId',
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