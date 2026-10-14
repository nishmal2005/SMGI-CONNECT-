

// lib/data/models/payment_model.dart

// ═══════════════════════════════════════════════════════════
// Payment Summary
// ═══════════════════════════════════════════════════════════
double? _parseNullableDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

class PaymentSummaryModel {
  final String applicationId;
  final double amount;
  final String currency;
  final String title;
  final String? description;
  final bool isPaid;
  final bool canPay;
  final String? status;

  PaymentSummaryModel({
    required this.applicationId,
    required this.amount,
    required this.currency,
    required this.title,
    this.description,
    required this.isPaid,
    required this.canPay,
    this.status,
  });

  factory PaymentSummaryModel.fromJson(Map<String, dynamic> json) {
    return PaymentSummaryModel(
      applicationId:
          (json['application_id'] ?? json['application'] ?? '').toString(),
      amount: _parseDouble(
        json['minimum_payment_required'] ??
            json['amount'] ??
            json['amount_in_rupees'] ??
            0,
      ),
      currency: json['currency'] ?? 'INR',
      title: json['title'] ?? json['description'] ?? 'Admission Fee',
      description: json['description'],
      isPaid: json['is_paid'] == true || json['status'] == 'paid',
      canPay: json['can_pay'] != false,
      status: json['status']?.toString(),
    );
  }

  static double _parseDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0;
    return 0;
  }

}

// ═══════════════════════════════════════════════════════════
// Payment Initiate (checkout session)
// ═══════════════════════════════════════════════════════════
class PaymentInitiateModel {
  final String orderId;
  final Map<String, dynamic>? sdkInitPayload;
  final Map<String, dynamic>? sdkPayload;
  final bool alreadyPaid;

  PaymentInitiateModel({
    required this.orderId,
    required this.sdkInitPayload,
    required this.sdkPayload,
    required this.alreadyPaid,
  });

  factory PaymentInitiateModel.fromJson(Map<String, dynamic> json) {
    final alreadyPaid = json['already_paid'] == true;
    final sdkInitPayload = _asJsonMap(json['sdk_init_payload']);
    final sdkPayload = _asJsonMap(json['sdk_payload']);
    if (!alreadyPaid && (sdkInitPayload == null || sdkPayload == null)) {
      throw const FormatException(
        'Payment initiation response is missing HyperSDK checkout payloads.',
      );
    }

    return PaymentInitiateModel(
      orderId: (json['order_id'] ?? '').toString(),
      sdkInitPayload: sdkInitPayload,
      sdkPayload: sdkPayload,
      alreadyPaid: alreadyPaid,
    );
  }

  static Map<String, dynamic>? _asJsonMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }
}

// ═══════════════════════════════════════════════════════════
// Payment Status (verified check)
// ═══════════════════════════════════════════════════════════
class PaymentStatusModel {
  final String status;
  final bool isPaid;
  final bool isFailed;
  final String? paymentId;
  final String? orderId;
  final String? gatewayStatus;
  final double? amount;
  final String? method;

  PaymentStatusModel({
    required this.status,
    required this.isPaid,
    required this.isFailed,
    this.paymentId,
    this.orderId,
    this.gatewayStatus,
    this.amount,
    this.method,
  });

  factory PaymentStatusModel.fromJson(Map<String, dynamic> json) {
    final status = (json['status'] ?? 'unknown').toString().toLowerCase();
    return PaymentStatusModel(
      status: status,
      isPaid: json['is_paid'] == true ||
          status == 'captured' ||
          status == 'paid' ||
          status == 'success' ||
          status == 'successful',
      isFailed: status == 'failed',
      paymentId: (json['payment_id'] ??
              json['transaction_id'] ??
              json['gateway_payment_id'])
          ?.toString(),
      orderId: (json['order_id'] ?? json['gateway_order_id'])?.toString(),
      gatewayStatus: json['gateway_status']?.toString(),
      amount: _parseNullableDouble(json['amount']),
      method: (json['method'] ?? json['payment_method'])?.toString(),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Payment Success (confirmed details)
// ═══════════════════════════════════════════════════════════
class PaymentSuccessModel {
  final String? paymentId;
  final String? orderId;
  final String? method;
  final double? amount; // INR
  final String? currency;
  final String? receiptUrl;
  final DateTime? paidAt;

  PaymentSuccessModel({
    this.paymentId,
    this.orderId,
    this.method,
    this.amount,
    this.currency,
    this.receiptUrl,
    this.paidAt,
  });

  factory PaymentSuccessModel.fromJson(Map<String, dynamic> json) {
    final rawPayment = json['payment'];
    final payment = rawPayment is Map
        ? Map<String, dynamic>.from(rawPayment)
        : json;
    return PaymentSuccessModel(
      paymentId: (payment['payment_id'] ??
              payment['transaction_id'] ??
              payment['gateway_payment_id'])
          ?.toString(),
      orderId: (payment['order_id'] ?? payment['gateway_order_id'])?.toString(),
      method: (payment['method'] ?? payment['payment_method'])?.toString(),
      amount: _parseNullableDouble(payment['amount']),
      currency: payment['currency']?.toString(),
      receiptUrl: payment['receipt_url']?.toString(),
      paidAt: payment['paid_at'] != null
          ? DateTime.tryParse(payment['paid_at'].toString())
          : null,
    );
  }

  String get formattedAmount {
    if (amount == null) return '';
    return '₹${amount!.toStringAsFixed(2)}';
  }

}

// ═══════════════════════════════════════════════════════════
// Payment History (list item)
// ═══════════════════════════════════════════════════════════
class PaymentModel {
  final String title;
  final String status;
  final String amount;
  final String transactionId;
  final DateTime? date;

  PaymentModel({
    required this.title,
    required this.status,
    required this.amount,
    required this.transactionId,
    this.date,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      title: json['title'] ?? json['description'] ?? '',
      status: json['status'] ?? '',
      amount: _formatAmount(json['amount']),
      transactionId: json['transaction_id'] ?? json['payment_id'] ?? '',
      date: _parseDate(
        json['date'] ??
            json['completed_at'] ??
            json['created_at'] ??
            json['paid_at'],
      ),
    );
  }

  /// Human-friendly date label, e.g. "12 Jan 2025 • 3:45 pm".
  /// Returns '—' when no date is available.
  String get dateTimeLabel {
    if (date == null) return '—';
    final d = date!;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final ampm = d.hour < 12 ? 'am' : 'pm';
    final m = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${months[d.month - 1]} ${d.year} • $h:$m $ampm';
  }

  /// True when the payment was successful (used by the history UI).
  bool get isSuccess =>
      status.toLowerCase() == 'success' ||
      status.toLowerCase() == 'successful';

  /// True when the payment is still pending.
  bool get isPending => status.toLowerCase() == 'pending';

  /// True when the payment failed.
  bool get isFailed => status.toLowerCase() == 'failed';

  static String _formatAmount(dynamic v) {
    if (v == null) return '';
    if (v is num) {
      // Heuristic: values above 10,000 are assumed to be in paise.
      // Adjust to match your backend convention.
      final rupees = v > 10000 ? v / 100 : v.toDouble();
      return '₹${rupees.toStringAsFixed(0)}';
    }
    final s = v.toString();
    return s.startsWith('₹') ? s : '₹$s';
  }

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    return DateTime.tryParse(v.toString());
  }
}