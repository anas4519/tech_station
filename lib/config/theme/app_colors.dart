import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primary: Dark Alpine Green ──
  static const Color primary = Color(0xFF0F3D2E);
  static const Color primaryLight = Color(0xFF1A5C45);
  static const Color primaryDark = Color(0xFF092A1F);
  static const Color primarySurface = Color(0xFFE8F5E9);

  // ── Accent ──
  static const Color accent = Color(0xFF4CAF50);
  static const Color accentLight = Color(0xFF81C784);

  // ── Neutrals ──
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ── Dark theme surfaces ──
  static const Color darkBg = Color(0xFF0D0D0D);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkCard = Color(0xFF242424);
  static const Color darkElevated = Color(0xFF2C2C2C);

  // ── Light theme surfaces ──
  static const Color lightBg = Color(0xFFF8FAF9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);

  // ── Semantic ──
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF29B6F6);

  // ── Score colors ──
  static const Color scoreExcellent = Color(0xFF2E7D32);
  static const Color scoreGood = Color(0xFF66BB6A);
  static const Color scoreAverage = Color(0xFFFFA726);
  static const Color scoreBelowAverage = Color(0xFFEF5350);

  static Color scoreColor(double score) {
    if (score >= 8.5) return scoreExcellent;
    if (score >= 7.0) return scoreGood;
    if (score >= 5.0) return scoreAverage;
    return scoreBelowAverage;
  }
}
