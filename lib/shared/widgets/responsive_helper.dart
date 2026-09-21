import 'package:flutter/material.dart';

class Responsive {
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;
}
