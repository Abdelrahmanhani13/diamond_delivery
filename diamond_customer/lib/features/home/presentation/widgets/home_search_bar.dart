import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_radius.dart';

/// Read-only search bar shown on Home; tapping navigates to the Search
/// screen (consistent with "ابحث عن منتج" placeholder in the Figma).
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 22.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                'ابحث عن منتج أو متجر',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
