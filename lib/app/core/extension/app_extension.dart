import 'package:flutter/material.dart';

class AppExtension {}

extension ThemeExtension on BuildContext {
  ThemeData get appTheme => Theme.of(this);
  ColorScheme get colorScheme => appTheme.colorScheme;
  TextTheme get textTheme => appTheme.textTheme;
  bool get isDark => appTheme.brightness == Brightness.dark;
  bool get isLight => appTheme.brightness == Brightness.light;
}
