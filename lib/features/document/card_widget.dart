import 'package:flutter/material.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/features/document/image.dart';
import 'package:smgi.connect/features/document/status_widgets.dart';
import 'package:smgi.connect/model/dummy_documentmodel.dart';

class DocumentCard extends StatelessWidget {
  final DocumentItem item;

  const DocumentCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DocumentImage(item.image),
        const SizedBox(width: 12),

        Expanded(
          child: Text(
            item.title,
            style: AppTextStyles.subtitle.copyWith(
              fontSize: 14,
              color: AppColors.black,
            ),
          ),
        ),

        StatusWidget(status: item.status),
      ],
    );
  }
}
