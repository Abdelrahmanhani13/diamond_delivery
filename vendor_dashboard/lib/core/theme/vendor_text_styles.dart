import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'vendor_colors.dart';

/// Vendor Dashboard typography.
/// Uses Cairo font (Arabic + Latin) consistent with Customer App.
class VendorTextStyles {
  VendorTextStyles._();

  static TextStyle _base({
    required double size,
    required FontWeight weight,
    Color color = VendorColors.textPrimary,
    double? height,
  }) {
    return GoogleFonts.cairo(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }

  // Display / Headings
  static TextStyle displayLarge = _base(size: 28, weight: FontWeight.w700);
  static TextStyle headingLarge = _base(size: 22, weight: FontWeight.w700);
  static TextStyle headingMedium = _base(size: 18, weight: FontWeight.w700);
  static TextStyle headingSmall = _base(size: 16, weight: FontWeight.w600);

  // Body
  static TextStyle bodyLarge = _base(size: 15, weight: FontWeight.w500);
  static TextStyle bodyMedium = _base(size: 14, weight: FontWeight.w400);
  static TextStyle bodySmall = _base(
    size: 12,
    weight: FontWeight.w400,
    color: VendorColors.textSecondary,
  );

  // Labels / Buttons
  static TextStyle buttonLarge = _base(
    size: 16,
    weight: FontWeight.w700,
    color: VendorColors.textOnPrimary,
  );
  static TextStyle buttonMedium = _base(
    size: 14,
    weight: FontWeight.w600,
    color: VendorColors.textOnPrimary,
  );

  static TextStyle caption = _base(
    size: 11,
    weight: FontWeight.w400,
    color: VendorColors.textHint,
  );

  static TextStyle price = _base(
    size: 16,
    weight: FontWeight.w700,
    color: VendorColors.primary,
  );
}
