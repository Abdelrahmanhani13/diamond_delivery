import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_radius.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum SocialProvider { google, facebook }

/// Social authentication button used on onboarding and auth screens.
class SocialAuthButton extends StatelessWidget {
  const SocialAuthButton({
    super.key,
    required this.provider,
    required this.label,
    this.onPressed,
  });

  final SocialProvider provider;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (provider) {
      SocialProvider.google => (Icons.g_mobiledata_rounded, const Color(0xFFDB4437)),
      SocialProvider.facebook => (Icons.facebook_rounded, const Color(0xFF1877F2)),
    };

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24.sp),
              SizedBox(width: 10.w),
              Text(
                label,
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
