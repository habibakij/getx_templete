import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary Palette
  static const primary = Color(0xFF6C63FF);
  static const primaryDark = Color(0xFF4A43CC);

  // Accent
  static const accent = Color(0xFF00D4AA);
  static const accentLight = Color(0xFF00F5C4);

  // Brand color
  static const pureRed = Color(0XFFE53935);
  static const pureWhite = Color(0XFFffffff);
  static const pureBlack = Color(0XFF000000);

  static const darkRed = Color(0XFFb32400);
  static const greyLite = Color(0XFF999999);

  static const greyShade100 = Color(0xFFF5F5F5);
  static const greyShade200 = Color(0xFFEEEEEE);
  static const greyShade300 = Color(0xFFE0E0E0);
  static const greyShade500 = Color(0xFF9E9E9E);

  static const darkBg = Color(0xFF0A0A0F);
  static const darkSurface = Color(0xFF13131A);
  static const darkCard = Color(0xFF1C1C28);
  static const darkCardBorder = Color(0xFF2A2A3E);
  static const darkNavBar = Color(0xFF16161F);

  // Light Theme Colors
  static const lightPrimaryText = Color(0XFF1C1C1E);
  static const lightSecondaryText = Color(0XFF3A3A3C);
  static const lightTertiaryText = Color(0XFF9C9C9C);

  // Dark Theme Colors
  static const darkPrimaryText = Color(0XFFF2F2F7);
  static const darkSecondaryText = Color(0XFFC7C7CC);
  static const darkTertiaryText = Color(0XFF8E8E93);

  // Text
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF8F8FA8);
  static const textMuted = Color(0xFF4A4A6A);

  // Status
  static const success = Color(0xFF00D4AA);
  static const warning = Color(0xFFFFB547);
  static const error = Color(0xFFFF6B6B);
  static const info = Color(0xFF4FC3F7);
}
