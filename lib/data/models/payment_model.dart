class PaymentModel {
  final String id;
  final String applicationId;
  final String amount;
  final String status;         // success | pending | failed
  final String paymentMethod;
  final String transactionId;
  final String paidAt;         // ISO-8601 string

  const PaymentModel({
    required this.id,
    required this.applicationId,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.transactionId,
    required this.paidAt,
  });

  /// Convenience label used by the payment-history card.
  String get title =>
      paymentMethod.isNotEmpty ? paymentMethod : 'Payment #$id';

  /// Human-readable date, e.g. `21 Feb 2026, 3:05 pm`.
  String get dateTimeLabel {
    final parsed = DateTime.tryParse(paidAt);
    if (parsed == null) return paidAt;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final h = parsed.hour % 12 == 0 ? 12 : parsed.hour % 12;
    final ampm = parsed.hour < 12 ? 'am' : 'pm';
    final m = parsed.minute.toString().padLeft(2, '0');
    return '${parsed.day} ${months[parsed.month - 1]} ${parsed.year}, '
        '$h:$m $ampm';
  }

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        id: json['id']?.toString() ?? '',
        applicationId: json['application_id']?.toString() ?? '',
        amount: json['amount']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
        paymentMethod: json['payment_method']?.toString() ?? '',
        transactionId: json['transaction_id']?.toString() ?? '',
        paidAt: json['paid_at']?.toString() ?? '',
      );
}