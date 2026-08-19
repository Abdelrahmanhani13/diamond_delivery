import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_radius.dart';

/// Row menu item used in the profile list (عناويني / المحفظة / المفضلة...).
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
    final Color color = destructive ? AppColors.error : AppColors.textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Icon(
              Icons.chevron_left_rounded,
              color: AppColors.textHint,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            if (trailingText != null) ...[
              Text(trailingText!, style: AppTextStyles.bodySmall),
              SizedBox(width: 8.w),
            ],
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.right,
                style: AppTextStyles.bodyLarge.copyWith(color: color),
              ),
            ),
            Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: destructive
                    ? AppColors.error.withValues(alpha: 0.1)
                    : AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, size: 17.sp, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
