import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/data/models/notification_model.dart';
import 'package:smgi.connect/viewmodels/notification_viewmodel.dart';


import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';


class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotificationViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Back ───────────────────────────────
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.accent,
                  size: 22.r,
                ),
              ),
              SizedBox(height: 12.h),

              // ── Title ──────────────────────────────
              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 16.h),

              // ── Body ───────────────────────────────
              Expanded(child: _buildBody(vm)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(NotificationViewModel vm) {
    if (vm.isLoading && vm.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.errorMessage != null && vm.items.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
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
        ),
      );
    }

    if (vm.items.isEmpty) {
      return Center(
        child: Text(
          'No notifications yet.',
          style: AppTextStyles.body2.copyWith(color: AppColors.gray),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: vm.load,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: vm.items.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (_, i) => _NotificationCard(item: vm.items[i]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Card
// ─────────────────────────────────────────────────────

class _NotificationCard extends StatelessWidget {
  final NotificationModel item;
  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final visuals = _iconFor(item.type);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Icon ───────────────────────────────
          CircleAvatar(
            radius: 18.r,
            backgroundColor: visuals.color,
            child: Icon(
              visuals.icon,
              size: 18.r,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 12.w),

          // ── Text ───────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      item.timeLabel,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  item.message,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade600,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ({IconData icon, Color color}) _iconFor(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return (icon: Icons.check, color: Colors.green);
      case NotificationType.pending:
        return (icon: Icons.more_horiz, color: Colors.amber.shade700);
      case NotificationType.reupload:
        return (icon: Icons.refresh, color: Colors.blue);
      case NotificationType.action:
        return (icon: Icons.flag, color: Colors.orange);
      case NotificationType.info:
        return (icon: Icons.info_outline, color: Colors.teal);
    }
  }
}