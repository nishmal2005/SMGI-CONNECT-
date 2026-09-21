import 'package:flutter/widgets.dart';

class Gap extends StatelessWidget {
  final double h;
  final double w;

  const Gap({this.h = 0, this.w = 0, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: h, width: w);
  }
}
