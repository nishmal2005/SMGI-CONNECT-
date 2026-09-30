import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/document_model.dart';
import '../../viewmodels/document_viewmodel.dart';
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

  Future<void> _onReupload(DocumentModel doc) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result == null || result.files.single.path == null) return;

    final file = File(result.files.single.path!);
    if (!mounted) return;

    final vm = context.read<DocumentViewModel>();
    final ok = await vm.reupload(doc: doc, file: file);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? '${doc.title} re-uploaded.'
              : (vm.errorMessage ?? 'Re-upload failed.'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DocumentViewModel>();

    return AppScaffold(
      body: Column(
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
    );
  }

  Widget _buildBody(DocumentViewModel vm) {
    if (vm.isLoading && vm.items.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

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
            TextButton(
              onPressed: vm.load,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

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
            child: _DocumentRow(
              item: vm.items[index],
              isUploading: vm.isUploading,
              onReupload: _onReupload,
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Row
// ─────────────────────────────────────────────────────

class _DocumentRow extends StatelessWidget {
  final DocumentModel item;
  final bool isUploading;
  final ValueChanged<DocumentModel> onReupload;

  const _DocumentRow({
    required this.item,
    required this.isUploading,
    required this.onReupload,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
        Expanded(
          child: Text(
            item.title.isEmpty ? '—' : item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.subtitle.copyWith(
              fontSize: 14.sp,
              color: AppColors.black,
            ),
          ),
        ),
        if (item.canReupload)
          SizedBox(
            height: 28.h,
            child: ElevatedButton(
              onPressed: isUploading ? null : () => onReupload(item),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE74C3C),
                disabledBackgroundColor:
                    const Color(0xFFE74C3C).withValues(alpha: 0.4),
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              child: Text(
                isUploading ? 'Uploading…' : 'Reupload',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        else
          StatusWidget(status: item.status),
      ],
    );
  }
}