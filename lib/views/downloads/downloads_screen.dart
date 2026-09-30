import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/download_model.dart';
import '../../viewmodels/downloads_viewmodel.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/back_app_bar.dart';
import '../../widgets/gap.dart';
import '../../widgets/gradient_button.dart';
import '../home/home_shell.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DownloadsViewModel>().load();
    });
  }

  void _onDone() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeShell()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DownloadsViewModel>();

    return AppScaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppSizes.appBarHeight),
        child: const BackAppBar(title: 'Downloads'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSizes.paddingLarge,
          AppSizes.paddingSmall,
          AppSizes.padding,
          AppSizes.paddingLarge,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────
            Text(
              'Downloads',
              style: AppTextStyles.pageTitle.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gap(h: 5),
            Text(
              'Acknowledgements & Forms related to your\n'
              'admission process.',
              style: AppTextStyles.condition.copyWith(fontSize: 14.sp),
            ),
            Gap(h: 12),

            // ── List ──────────────────────────────────
            Expanded(child: _buildBody(vm)),

            // ── Done ──────────────────────────────────
            Gap(h: 16),
            GradientButton(
              text: 'Done',
              onTap: _onDone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(DownloadsViewModel vm) {
    if (vm.isLoading && vm.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.errorMessage != null && vm.items.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.paddingLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                vm.errorMessage!,
                textAlign: TextAlign.center,
                style: AppTextStyles.body2.copyWith(color: AppColors.error),
              ),
              Gap(h: 12),
              TextButton(
                onPressed: vm.load,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    if (vm.items.isEmpty) {
      return Center(
        child: Text(
          'No documents available yet.',
          style: AppTextStyles.body2.copyWith(color: AppColors.gray),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: vm.load,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: vm.items.length,
        itemBuilder: (_, i) => _DownloadCard(item: vm.items[i]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Card
// ─────────────────────────────────────────────────────

class _DownloadCard extends StatelessWidget {
  final DownloadModel item;
  const _DownloadCard({required this.item});

  void _onDownload(BuildContext context) {
    final url = item.fileUrl;
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document not available.')),
      );
      return;
    }
    // TODO: launch with url_launcher.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening: $url')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.fromLTRB(7.w, 7.h, 7.w, 6.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(9.r),
        border: Border.all(color: const Color(0xFFE7E7E7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Icon ─────────────────────────────
          Container(
            width: 32.r,
            height: 32.r,
            decoration: const BoxDecoration(
              color: AppColors.black,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.description,
              color: AppColors.accent,
              size: 17.r,
            ),
          ),
          Gap(w: 8),

          // ── Content ──────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                ),
                Gap(h: 2),
                Text(
                  item.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: AppColors.gray,
                    fontSize: 9.sp,
                  ),
                ),
                Gap(h: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 24.h,
                    child: ElevatedButton.icon(
                      onPressed: () => _onDownload(context),
                      icon: Image.asset(
                        'assets/images/downloadicon.png',
                        width: 12.r,
                        height: 12.r,
                      ),
                      label: Text(
                        'Download',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: AppColors.white,
                          fontSize: 9.sp,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r),
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
}