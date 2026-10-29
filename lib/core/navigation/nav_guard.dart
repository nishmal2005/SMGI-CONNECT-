import 'package:flutter/material.dart';

/// Prevents duplicate pushes of the same logical screen when the user
/// rapid-taps a button. Uses a static Set so the guard survives widget
/// rebuilds / remounts.
class NavGuard {
  static final Set<String> _pushing = {};

  static bool tryBegin(String key) {
    if (_pushing.contains(key)) return false;
    _pushing.add(key);
    return true;
  }

  static void end(String key) {
    _pushing.remove(key);
  }

  static Future<T?>? push<T>(
    BuildContext context,
    Widget page, {
    required String key,
  }) {
    if (!tryBegin(key)) return null;
    return Navigator.push<T>(
      context,
      MaterialPageRoute(builder: (_) => page),
    ).whenComplete(() => end(key));
  }
}