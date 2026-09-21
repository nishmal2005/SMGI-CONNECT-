import 'package:flutter/material.dart';
import 'package:smgi.connect/features/menu/menuscreen.dart';
import 'package:smgi.connect/features/profile/profile_screen.dart'; // adjust to actual path
import 'package:smgi.connect/notification/notification_screen.dart';

/// Simple data model for a single referral entry.
class ReferralCodeModel {
  final String referralCode;
  final String status;
  final String course;
  final String referredByName;
  final String referredById;
  final String referrerName;
  final String referrerId;
  final String referrerMobile;
  final String referrerState;

  const ReferralCodeModel({
    required this.referralCode,
    required this.status,
    required this.course,
    required this.referredByName,
    required this.referredById,
    required this.referrerName,
    required this.referrerId,
    required this.referrerMobile,
    required this.referrerState,
  });

  factory ReferralCodeModel.fromJson(Map<String, dynamic> json) {
    return ReferralCodeModel(
      referralCode: json['referral_code'] ?? 'SMGI2025REF89',
      status: json['status'] ?? 'Applied',
      course: json['course'] ?? 'BSc Nursing (4 years)',
      referredByName: json['referred_by_name'] ?? 'Akhil P.',
      referredById: json['referred_by_id'] ?? 'RF12873',
      referrerName: json['referrer_name'] ?? 'Akhil P.',
      referrerId: json['referrer_id'] ?? 'RF12873',
      referrerMobile: json['referrer_mobile'] ?? '+91 98765 43232',
      referrerState: json['referrer_state'] ?? 'Kerala',
    );
  }
}

/// Mock referral data — swap this for a real API call once the backend is ready.
const List<ReferralCodeModel> _mockReferrals = [
  ReferralCodeModel(
    referralCode: 'SMGI2025REF89',
    status: 'Applied',
    course: 'BSc Nursing (4 years)',
    referredByName: 'Akhil P.',
    referredById: 'RF12873',
    referrerName: 'Akhil P.',
    referrerId: 'RF12873',
    referrerMobile: '+91 98765 43232',
    referrerState: 'Kerala',
  ),
];

class ReferralHistoryScreen extends StatefulWidget {
  const ReferralHistoryScreen({super.key});

  @override
  State<ReferralHistoryScreen> createState() => _ReferralHistoryScreenState();
}

class _ReferralHistoryScreenState extends State<ReferralHistoryScreen> {
  static const Color primaryOrange = Color(0xFFF5A623);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF3F4F8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: _mockReferrals.length,
                itemBuilder: (context, index) {
                  return _ReferralCard(referral: _mockReferrals[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circleIconButton(
                icon: Icons.menu,
                iconColor: primaryOrange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyAccountPage(
                        name: 'Student',
                        course: 'Course not selected',
                        status: ApplicationStatus.inProgress,
                      ),
                    ),
                  );
                },
              ),
              Row(
                children: [
                  _circleIconButton(
                    icon: Icons.notifications_none,
                    iconColor: primaryOrange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 22,
                      backgroundColor: Color(0xFFE0E0E0),
                      backgroundImage: AssetImage(
                        'assets/images/avatar_placeholder.png',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Referral Code',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }
}

class _ReferralCard extends StatelessWidget {
  final ReferralCodeModel referral;

  const _ReferralCard({required this.referral});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.qr_code_2, size: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '1 Referral Code',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      referral.referralCode,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(status: referral.status),
            ],
          ),
          const SizedBox(height: 14),
          _infoRow('Course:', referral.course),
          const SizedBox(height: 6),
          _infoRow(
            'Referred By:',
            '${referral.referredByName} (ID: ${referral.referredById})',
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          _ReferrerDetailsBox(referral: referral),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 13, color: Colors.black45),
        children: [
          TextSpan(text: '$label '),
          TextSpan(
            text: value,
            style: const TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isApplied = status.toLowerCase() == 'applied';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          status,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isApplied ? const Color(0xFF34A853) : Colors.black54,
          ),
        ),
        const SizedBox(width: 4),
        if (isApplied)
          const Icon(Icons.check_circle, color: Color(0xFF34A853), size: 16),
      ],
    );
  }
}

class _ReferrerDetailsBox extends StatelessWidget {
  final ReferralCodeModel referral;

  const _ReferrerDetailsBox({required this.referral});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'REFERRER DETAILS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3366CC),
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),
          _detailRow(
            'Name :',
            '${referral.referrerName} (ID: ${referral.referrerId})',
          ),
          const SizedBox(height: 6),
          _detailRow('Mobile :', referral.referrerMobile),
          const SizedBox(height: 6),
          _detailRow('State :', referral.referrerState),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black45),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
