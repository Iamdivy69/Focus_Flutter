import 'package:flutter/material.dart';

/// Dart extension methods used across the app.

extension StringExtensions on String {
  /// Capitalises the first letter of the string.
  String get capitalised =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Converts snake_case or SCREAMING_SNAKE to Title Case.
  String get titleCase => split('_')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
      .join(' ');

  /// Returns the string with a leading '@' if not already present.
  String get withAtSign => startsWith('@') ? this : '@$this';

  /// Strips a leading '@' if present.
  String get withoutAtSign => startsWith('@') ? substring(1) : this;
}

extension IntExtensions on int {
  /// Formats minutes as "Xh Ym".
  String get asMinuteLabel {
    if (this < 60) return '${this}m';
    final h = this ~/ 60;
    final m = this % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }

  /// Clamps the value between [min] and [max].
  int clampTo(int min, int max) => clamp(min, max).toInt();
}

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
