import 'package:flutter/material.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// Background
          Image.asset(
            'assets/images/Payment Success.png',
            fit: BoxFit.cover,
          ),
          /// Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Success Icon (SMALL – matches screenshot)
                  Image.asset(
                    'assets/images/success.png',
                    width: 60, // 👈 important
                    height: 60,
                  ),
                  const SizedBox(height: 16),
                  /// Title
                  Text(
                    'Payment Successful',
                    style: AppTextStyles.headline,
                  ),
                  const SizedBox(height: 4),
                  /// Merchant
                  Text(
                    'to Shri Maruthi group',
                    style: AppTextStyles.captionone,
                  ),
                  const SizedBox(height: 20),
                  /// Date
                  Text(
                    '15 May 2020 8:00 am',
                    style: AppTextStyles.captionone,
                  ),
                  const SizedBox(height: 20),
                  /// Payment Method
                  Text(
                    'Payment Method: Axis Bank 5462',
                    style: AppTextStyles.captionone,
                  ),
                  const SizedBox(height: 8),
                  /// Transaction ID + Copy icon
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'UPI Transaction ID: 432482498476',
                        style: AppTextStyles.captionone,
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.copy,
                        size: 16,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
