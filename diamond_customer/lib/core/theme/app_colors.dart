import 'package:flutter/material.dart';

/// Centralized color palette for Diamond Village Customer App.
class AppColors {
  AppColors._();

  // Brand / semantic colors (Light Mode Defaults)
  static const Color primary = Color(0xFF0F7A6D);
  static const Color accent = Color(0xFFF2A93B);
  static const Color success = Color(0xFF149C2E);
  static const Color error = Color(0xFFB31A1A);
  static const Color surface = Color(0xFFFFFFFF);

  // Extended Light Neutrals
  static const Color primaryDark = Color(0xFF0B5C52);
  static const Color primaryLight = Color(0xFFE6F2F0);

  static const Color background = Color(0xFFF5F6F8);
  static const Color scaffoldBackground = Color(0xFFF7F8F9);

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFEFF1F3);
  static const Color disabled = Color(0xFFD1D5DB);

  static const Color grey = Color(0xFF9CA3AF);
  static const Color greyLight = Color(0xFFF2F3F5);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color warning = Color(0xFFF2A93B);
  static const Color info = Color(0xFF2E7BB3);
  static const Color rating = Color(0xFFF2A93B);
  static const Color shadow = Color(0x1A0F7A6D);

  // Dark Mode Tokens (Slate Dark Theme)
  static const Color darkPrimary = Color(0xFF149C88);
  static const Color darkScaffoldBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextHint = Color(0xFF64748B);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkDivider = Color(0xFF1E293B);
  static const Color darkGreyLight = Color(0xFF334155);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
}

/// Context-aware extension to dynamically retrieve Light/Dark theme colors
extension AppThemeColorsExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get scaffoldBackgroundColor => isDarkMode
      ? AppColors.darkScaffoldBackground
      : AppColors.scaffoldBackground;

  Color get surfaceColor =>
      isDarkMode ? AppColors.darkSurface : AppColors.surface;

  Color get textPrimaryColor =>
      isDarkMode ? AppColors.darkTextPrimary : AppColors.textPrimary;

  Color get textSecondaryColor =>
      isDarkMode ? AppColors.darkTextSecondary : AppColors.textSecondary;

  Color get greyLightColor =>
      isDarkMode ? AppColors.darkGreyLight : AppColors.greyLight;

  Color get borderColor =>
      isDarkMode ? AppColors.darkBorder : AppColors.border;

  Color get primaryThemeColor =>
      isDarkMode ? AppColors.darkPrimary : AppColors.primary;
}
