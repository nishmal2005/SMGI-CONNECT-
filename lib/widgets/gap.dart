import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Use `Gap(h: 16, w: 12)` — values are treated as design-pixels
/// and scaled automatically. Do NOT pass `.h`/`.w` yourself.
class Gap extends StatelessWidget {
  final double h;
  final double w;

  const Gap({this.h = 0, this.w = 0, super.key});

  @override
  Widget build(BuildContext context) =>
      SizedBox(height: h.h, width: w.w);
}