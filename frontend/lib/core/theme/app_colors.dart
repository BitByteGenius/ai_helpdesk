import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette - Modern Indigo SaaS
  static const Color primary = Color(0xFF4F46E5); // Indigo 600
  static const Color primaryLight = Color(0xFF6366F1); // Indigo 500
  static const Color primaryDark = Color(0xFF3730A3); // Indigo 800
  static const Color primarySubtle = Color(0xFFEEF2FF); // Indigo 50
  static const Color primarySubtleLight = Color(0xFFEEF2FF);
  static const Color primarySubtleDark = Color(0xFF312E81); // Indigo 900

  // Secondary / Sky
  static const Color secondary = Color(0xFF0EA5E9); // Sky 500
  static const Color secondaryLight = Color(0xFF38BDF8);
  static const Color secondaryDark = Color(0xFF0369A1);

  // Backgrounds & Surfaces (Light)
  static const Color background = Color(0xFFF8FAFC); // Slate 50
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color card = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color surfaceSubtle = Color(0xFFF1F5F9); // Slate 100
  static const Color lightSurfaceSubtle = Color(0xFFF1F5F9);

  // Backgrounds & Surfaces (Dark)
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkCard = Color(0xFF1E293B); // Slate 800
  static const Color darkSurfaceSubtle = Color(0xFF334155); // Slate 700

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0); // Slate 200
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9); // Slate 100
  static const Color lightBorderLight = Color(0xFFF1F5F9);
  static const Color borderDark = Color(0xFF334155);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkBorderLight = Color(0xFF1E293B);

  // Text (Light)
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Text (Dark)
  static const Color textDarkPrimary = Color(0xFFF8FAFC);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color textDarkSecondary = Color(0xFF94A3B8);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color textDarkMuted = Color(0xFF64748B);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Status & Priority Accents
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color successSubtle = Color(0xFFD1FAE5);
  static const Color successDark = Color(0xFF065F46);

  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorSubtle = Color(0xFFFEE2E2);
  static const Color errorDark = Color(0xFF991B1B);

  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningSubtle = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFF92400E);

  static const Color info = Color(0xFF3B82F6); // Blue 500
  static const Color infoLight = Color(0xFFDBEAFE);
  static const Color infoSubtle = Color(0xFFDBEAFE);
  static const Color infoDark = Color(0xFF1E40AF);

  static const Color purple = Color(0xFF8B5CF6); // Purple 500
  static const Color purpleLight = Color(0xFFEDE9FE);
  static const Color purpleSubtle = Color(0xFFEDE9FE);

  static const Color accent = Color(0xFF4F46E5);
}

/// Dynamic theme-aware convenience extension on BuildContext
extension AppThemeContext on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get cardBg => isDark ? AppColors.darkCard : AppColors.card;
  Color get scaffoldBg => Theme.of(this).scaffoldBackgroundColor;
  Color get textPrimary => isDark ? AppColors.textDarkPrimary : AppColors.textPrimary;
  Color get textSecondary => isDark ? AppColors.textDarkSecondary : AppColors.textSecondary;
  Color get textMuted => isDark ? AppColors.textDarkMuted : AppColors.textMuted;
  Color get border => isDark ? AppColors.borderDark : AppColors.border;
  Color get borderLight => isDark ? AppColors.darkBorderLight : AppColors.borderLight;
  Color get primaryColor => isDark ? AppColors.primaryLight : AppColors.primary;
  Color get primarySubtle => isDark ? AppColors.primarySubtleDark : AppColors.primarySubtle;
  Color get surfaceSubtle => isDark ? AppColors.darkSurfaceSubtle : AppColors.surfaceSubtle;
}
