import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

/// Centralized typography for Diamond Village Customer App.
/// Font family: Cairo (Arabic + Latin, RTL).
/// Never create TextStyle directly in screens/widgets — always use these.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle _base({
    required double size,
    required FontWeight weight,
    Color color = AppColors.textPrimary,
    double? height,
  }) {
    return GoogleFonts.cairo(
      fontSize: size.sp,
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
    color: AppColors.textSecondary,
  );

  // Labels / Buttons
  static TextStyle buttonLarge = _base(
    size: 16,
    weight: FontWeight.w700,
    color: AppColors.textOnPrimary,
  );
  static TextStyle buttonMedium = _base(
    size: 14,
    weight: FontWeight.w600,
    color: AppColors.textOnPrimary,
  );

  static TextStyle caption = _base(
    size: 11,
    weight: FontWeight.w400,
    color: AppColors.textHint,
  );

  static TextStyle price = _base(
    size: 16,
    weight: FontWeight.w700,
    color: AppColors.primary,
  );

  static TextStyle link = _base(
    size: 14,
    weight: FontWeight.w600,
    color: AppColors.primary,
  );

  static TextStyle errorText = _base(
    size: 12,
    weight: FontWeight.w400,
    color: AppColors.error,
  );
}
