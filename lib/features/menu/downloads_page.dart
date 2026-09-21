import 'package:flutter/material.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/shared/widgets/app_scaffold.dart';

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  static const items = [
    ['Admission Acknowledgment', 'Confirmation of submitted details'],
    ['Fee Payment Acknowledgment', 'Acknowledgement of fee payment rules'],
    ['Document Submission Form', 'Required document checklist'],
    ['Documents and Forms', 'Required for admission verification'],
  ];

  @override
  Widget build(BuildContext context) => AppScaffold(
    body: ListView(
      padding: const EdgeInsets.fromLTRB(24, 4, 16, 20),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 18,
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.accent,
              size: 17,
            ),
          ),
        ),
        const SizedBox(height: 25),
        const Text(
          'Downloads',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Acknowledgements & Forms related to your\nadmission process.',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: AppColors.gray,
            fontSize: 14,
            //  height: 3,
          ),
        ),
        const SizedBox(height: 12),
        for (final item in items) _card(item[0], item[1]),
      ],
    ),
  );

  Widget _card(String title, String subtitle) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.fromLTRB(7, 7, 7, 6),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(9),
      border: Border.all(color: const Color(0xFFE7E7E7)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x12000000),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.black,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.description,
            color: AppColors.accent,
            size: 17,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.gray,
                  fontSize: 9,
                ),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 24,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/images/downloadicon.png',
                         // width: 12,
                    //  height: 12,
                    ),
                    label: const Text(
                      'Download',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: AppColors.white,
                        fontSize: 9,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
