import 'package:flutter/material.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/features/menu/downloads_page.dart';
import 'package:smgi.connect/shared/widgets/app_scaffold.dart';
import 'package:smgi.connect/shared/widgets/gap.dart';

/// Backend-driven status. Map your API string to this enum wherever you parse the response.
enum ApplicationStatus { inProgress, submitted, approved }

extension ApplicationStatusX on ApplicationStatus {
  String get label => switch (this) {
    ApplicationStatus.inProgress => 'Application in Progress',
    ApplicationStatus.submitted => 'Application Submitted',
    ApplicationStatus.approved => 'Application Approved',
  };

  Color get color => switch (this) {
    ApplicationStatus.inProgress => const Color(0xFFF1C40F),
    ApplicationStatus.submitted => const Color(0xFF3498DB),
    ApplicationStatus.approved => const Color(0xFF2ECC71),
  };
}

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({
    super.key,
    required this.name,
    required this.course,
    required this.status,
    this.imageUrl,
  });

  final String name;
  final String course;
  final ApplicationStatus status;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) => AppScaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.arrow_back),
              color: AppColors.accent,
              onPressed: () => Navigator.pop(context),
            ),
            const Gap(h: 16),
            _profileCard(),
            const Gap(h: 12),
            _downloadsCard(context),
          ],
        ),
      ),
    ),
  );

  Widget _card({required Widget child}) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(offset: Offset(0, 1), blurRadius: 4, color: Colors.black12),
      ],
    ),
    child: child,
  );

  Widget _profileCard() => _card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      width: 70,
                      height: 76,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/person.jpeg',
                      width: 70,
                      height: 76,
                      fit: BoxFit.cover,
                    ),
            ),
            const Gap(w: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.subtitle.copyWith(
                      fontSize: 22,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const Gap(h: 4),
                  Text(
                    course,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9BA3B0),
                    ),
                  ),
                  const Gap(h: 6),
                  _statusTag(status),
                ],
              ),
            ),
          ],
        ),
        const Gap(h: 10),
        Text(
          'My Account',
          style: AppTextStyles.body2.copyWith(
            fontSize: 12,
            color: const Color(0xFF0A4D9F),
          ),
        ),
      ],
    ),
  );

  Widget _downloadsCard(BuildContext context) => InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DownloadsPage()),
      );
    },
    borderRadius: BorderRadius.circular(12),
    child: _card(
      child: Row(
        children: [
          const Icon(
            Icons.description_outlined,
            color: Color(0xFF0A4D9F),
            size: 22,
          ),
          const Gap(w: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Downloads',
                  style: AppTextStyles.body2.copyWith(
                    fontSize: 15,
                    color: const Color(0xFF0A4D9F),
                  ),
                ),
                const Text(
                  'Guides & Forms',
                  style: TextStyle(fontSize: 12, color: Color(0xFF9BA3B0)),
                ),
              ],
            ),
          ),
          const Icon(Icons.download, size: 20, color: Color(0xFF9BA3B0)),
        ],
      ),
    ),
  );

  Widget _statusTag(ApplicationStatus status) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.circle, size: 6, color: status.color),
      const Gap(w: 6),
      Text(
        status.label,
        style: AppTextStyles.condition.copyWith(color: status.color),
      ),
    ],
  );
}
