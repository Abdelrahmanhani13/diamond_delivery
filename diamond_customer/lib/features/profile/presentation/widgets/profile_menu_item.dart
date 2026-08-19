import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_radius.dart';

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.trailingText,
    this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final String? trailingText;
  final VoidCallback? onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final Color textColor = destructive ? AppColors.error : context.textPrimaryColor;
    final Color iconBg = destructive
        ? AppColors.error.withValues(alpha: 0.1)
        : (context.isDarkMode ? AppColors.darkGreyLight : AppColors.primaryLight);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        child: Row(
          children: [
            Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(
                icon,
                size: 17.sp,
                color: destructive ? AppColors.error : context.primaryThemeColor,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyLarge.copyWith(color: textColor),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: context.textSecondaryColor,
                ),
              ),
              SizedBox(width: 8.w),
            ],
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: context.textSecondaryColor,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}
