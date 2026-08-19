import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_radius.dart';

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
          color: context.greyLightColor,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: context.textSecondaryColor, size: 22.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                context.tr('searchPlaceholder'),
                style: AppTextStyles.bodyMedium.copyWith(color: context.textSecondaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
