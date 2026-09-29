import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smgi.connect/data/models/document_model.dart';


class StatusWidget extends StatelessWidget {
  final DocumentStatus status;

  const StatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case DocumentStatus.verified:
        return _text('Verified', const Color(0xFF2ECC71));

      case DocumentStatus.pending:
        return _text('Pending', const Color(0xFFF1C40F));

      case DocumentStatus.rejected:
        return _text('Rejected', const Color(0xFFE74C3C));

      case DocumentStatus.reupload:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE74C3C),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            'Reupload',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
    }
  }

  Widget _text(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: color,
      ),
    );
  }
}