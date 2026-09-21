import 'package:flutter/material.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';

class PaymentCardWidget extends StatelessWidget {
  final String title;
  final String dateTime;
  final String amount;
  final String status;

  const PaymentCardWidget({
    super.key,
    required this.title,
    required this.dateTime,
    required this.amount,
    required this.status,
  });

  Color _statusColor() {
    switch (status) {
      case "Success":
        return AppColors.success;
      case "Pending":
        return AppColors.warning;
      case "Failed":
        return AppColors.error;
      default:
        return AppColors.black;
    }
  }

  Widget _buildFinanceIcon() {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF070D19), Color(0xFF0085FF)],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.asset(
            "assets/images/cardicon.png",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildFinanceIcon(),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body2.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(dateTime, style: AppTextStyles.condition),
            ],
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount,
              style: AppTextStyles.body3.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(
                color: _statusColor(),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
