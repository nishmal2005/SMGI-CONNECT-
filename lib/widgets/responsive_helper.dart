import 'package:flutter/widgets.dart';

/// Breakpoint helper — use for structural decisions (columns count,
/// tablet-only sidebars), NOT for sizing. Sizing is ScreenUtil's job.
class Responsive {
  Responsive._();

  /// Phone-small  : < 375
  /// Phone        : 375 – 599
  /// Tablet       : 600 – 899
  /// Large tablet : >= 900
  static const double tabletBreakpoint = 600;
  static const double largeBreakpoint = 900;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakpoint;

  static bool isLarge(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= largeBreakpoint;

  static bool isPhone(BuildContext context) =>
      MediaQuery.sizeOf(context).width < tabletBreakpoint;

  /// Max width for centred content on wide screens.
  static double contentMaxWidth(BuildContext context) =>
      isTablet(context) ? 500 : double.infinity;
}