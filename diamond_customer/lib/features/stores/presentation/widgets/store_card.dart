import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/widgets/app_asset_image.dart';

/// Premium store list card, using actual food photo assets,
/// modern badges, and structured spacing.
class StoreCard extends StatelessWidget {
  const StoreCard({
    super.key,
    required this.name,
    required this.category,
    required this.rating,
    required this.deliveryTime,
    required this.isOpen,
    this.onTap,
  });

  final String name;
  final String category;
  final double rating;
  final String deliveryTime;
  final bool isOpen;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                // Store image thumbnail with offline overlay if closed
                Stack(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: AppColors.greyLight,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: AppAssetImage(
                          assetPath: Assets.images.storeImage,
                          width: 80.w,
                          height: 80.w,
                          fit: BoxFit.cover,
                          fallbackIcon: Icons.storefront_rounded,
                        ),
                      ),
                    ),
                    if (!isOpen)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.black.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'مغلق',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                
                SizedBox(width: 14.w),
                
                // Store detailed specifications
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        category,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(Icons.star_rounded, size: 16.sp, color: AppColors.rating),
                          SizedBox(width: 3.w),
                          Text(
                            '$rating',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Icon(Icons.access_time_rounded, size: 14.sp, color: AppColors.textSecondary),
                          SizedBox(width: 4.w),
                          Text(
                            deliveryTime,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Action Indicator
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.textHint,
                  size: 14.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
