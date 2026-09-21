import 'package:flutter/material.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/dummy/data.dart';
import 'package:smgi.connect/features/document/card_widget.dart';
import 'package:smgi.connect/shared/widgets/app_bar.dart';
import 'package:smgi.connect/shared/widgets/app_scaffold.dart';

class DocumentVaultScreen extends StatelessWidget {
  const DocumentVaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AppScaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HomeAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * .04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Documents',
                        style: AppTextStyles.subtitle.copyWith(
                          fontSize: 14,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      /// 👆 SINGLE WHITE CARD ENDS HERE
                      Container(
                        padding: EdgeInsets.all(size.width * 0.04),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: List.generate(
                            documents.length,
                            (index) => Padding(
                              padding: EdgeInsets.only(
                                bottom: index == documents.length - 1 ? 0 : 16,
                              ),
                              child: DocumentCard(item: documents[index]),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
