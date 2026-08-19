import 'package:flutter/material.dart';
import 'vendor_colors.dart';
import 'vendor_text_styles.dart';

/// Vendor Dashboard ThemeData
/// Matches the Customer app's overall look & feel.
class VendorTheme {
  VendorTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: VendorColors.scaffoldBackground,
      primaryColor: VendorColors.primary,
      colorScheme: const ColorScheme.light(
        primary: VendorColors.primary,
        secondary: VendorColors.accent,
        error: VendorColors.error,
        surface: VendorColors.surface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: VendorColors.surface,
        foregroundColor: VendorColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: VendorTextStyles.headingMedium,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: VendorColors.primary,
          foregroundColor: VendorColors.white,
          textStyle: VendorTextStyles.buttonMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: VendorColors.primary,
          textStyle: VendorTextStyles.buttonMedium.copyWith(color: VendorColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: const BorderSide(color: VendorColors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: VendorColors.greyLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: VendorColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: VendorColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: VendorColors.error),
        ),
        labelStyle: VendorTextStyles.bodyMedium.copyWith(color: VendorColors.textHint),
        hintStyle: VendorTextStyles.bodySmall,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        color: VendorColors.surface,
      ),
      dividerTheme: const DividerThemeData(
        color: VendorColors.divider,
        thickness: 1,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: VendorColors.primary,
        foregroundColor: VendorColors.white,
        elevation: 4,
      ),
    );
  }
}
