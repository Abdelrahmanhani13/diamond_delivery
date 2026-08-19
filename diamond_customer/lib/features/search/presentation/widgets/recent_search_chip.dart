import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_radius.dart';

/// Chip used for recent search terms, with a small remove (x) affordance.
class RecentSearchChip extends StatelessWidget {
  const RecentSearchChip({super.key, required this.label, this.onTap, this.onRemove});

  final String label;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history_rounded, size: 15.sp, color: AppColors.textSecondary),
            SizedBox(width: 6.w),
            Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
            if (onRemove != null) ...[
              SizedBox(width: 6.w),
              InkWell(
                onTap: onRemove,
                child: Icon(Icons.close_rounded, size: 14.sp, color: AppColors.textHint),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
