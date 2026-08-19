import 'package:flutter/material.dart';

/// Vendor Dashboard color palette.
/// Matches the Diamond Village design system but uses a distinct
/// accent to differentiate the Vendor side from the Customer side.
class VendorColors {
  VendorColors._();

  // Brand
  static const Color primary = Color(0xFF0F7A6D);
  static const Color primaryDark = Color(0xFF0B5C52);
  static const Color primaryLight = Color(0xFFE6F2F0);
  static const Color accent = Color(0xFFF2A93B);

  // Status
  static const Color success = Color(0xFF149C2E);
  static const Color error = Color(0xFFB31A1A);
  static const Color warning = Color(0xFFF2A93B);
  static const Color info = Color(0xFF2E7BB3);

  // Surfaces
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F6F8);
  static const Color scaffoldBackground = Color(0xFFF7F8F9);

  // Text
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Borders / Dividers
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFEFF1F3);
  static const Color disabled = Color(0xFFD1D5DB);

  // Neutrals
  static const Color grey = Color(0xFF9CA3AF);
  static const Color greyLight = Color(0xFFF2F3F5);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color shadow = Color(0x1A0F7A6D);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
}
