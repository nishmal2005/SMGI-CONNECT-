class ReferralModel {
  final String referralCode;
  final String status;
  final String course;
  final String referrerName;
  final String referrerId;
  final String referrerMobile;
  final String referrerState;

  const ReferralModel({
    required this.referralCode,
    required this.status,
    required this.course,
    required this.referrerName,
    required this.referrerId,
    required this.referrerMobile,
    required this.referrerState,
  });

  factory ReferralModel.fromJson(Map<String, dynamic> json) => ReferralModel(
        referralCode: json['referral_code']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
        course: json['course']?.toString() ?? '',
        referrerName: json['referrer_name']?.toString() ?? '',
        referrerId: json['referrer_id']?.toString() ?? '',
        referrerMobile: json['referrer_mobile']?.toString() ?? '',
        referrerState: json['referrer_state']?.toString() ?? '',
      );
}