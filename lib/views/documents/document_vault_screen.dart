import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_sizes.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/data/models/document_model.dart';
import 'package:smgi.connect/viewmodels/document_viewmodel.dart';

import '../../widgets/app_bar.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/status_widget.dart';

class DocumentVaultScreen extends StatefulWidget {
  const DocumentVaultScreen({super.key});

  @override
  State<DocumentVaultScreen> createState() => _DocumentVaultScreenState();
}

class _DocumentVaultScreenState extends State<DocumentVaultScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DocumentViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DocumentViewModel>();

    return AppScaffold(
      padding: EdgeInsets.zero,
      body: SafeArea(
        child: Column(
          children: [
            const HomeAppBar(),

            Expanded(
              child: RefreshIndicator(
                onRefresh: vm.load,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.padding,
                    vertical: AppSizes.padding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Documents',
                        style: AppTextStyles.subtitle.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      _buildBody(vm),
                      SizedBox(height: 32.h),
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

  Widget _buildBody(DocumentViewModel vm) {
    // ── Loading ────────────────────────────────────
    if (vm.isLoading && vm.items.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // ── Error ──────────────────────────────────────
    if (vm.errorMessage != null && vm.items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSizes.paddingLarge),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              vm.errorMessage!,
              textAlign: TextAlign.center,
              style: AppTextStyles.body2.copyWith(color: AppColors.error),
            ),
            SizedBox(height: 12.h),
            TextButton(onPressed: vm.load, child: const Text('Retry')),
          ],
        ),
      );
    }

    // ── Empty ──────────────────────────────────────
    if (vm.items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSizes.paddingLarge),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
        child: Center(
          child: Text(
            'No documents uploaded yet.',
            style: AppTextStyles.body2.copyWith(color: AppColors.gray),
          ),
        ),
      );
    }

    // ── Loaded ─────────────────────────────────────
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(vm.items.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == vm.items.length - 1 ? 0 : 16.h,
            ),
            child: _DocumentRow(item: vm.items[index]),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// One row inside the vault card
// ─────────────────────────────────────────────────────

class _DocumentRow extends StatelessWidget {
  final DocumentModel item;
  const _DocumentRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ── Thumbnail ──────────────────────────
        Container(
          height: 42.r,
          width: 42.r,
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Image.asset(
            item.image,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(
              Icons.description_outlined,
              size: 20.r,
              color: AppColors.primary,
            ),
          ),
        ),
        SizedBox(width: 12.w),

        // ── Title ──────────────────────────────
        Expanded(
          child: Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.subtitle.copyWith(
              fontSize: 14.sp,
              color: AppColors.black,
            ),
          ),
        ),

        // ── Status ─────────────────────────────
        StatusWidget(status: item.status),
      ],
    );
  }
}
