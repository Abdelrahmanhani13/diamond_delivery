import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/assets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_asset_image.dart';

/// A single product row tile showing image, name, description, price,
/// and an add-to-cart / quantity stepper control.
class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    this.imageUrl,
    required this.quantityInCart,
    required this.onAdd,
    required this.onIncrement,
    required this.onDecrement,
    required this.onTap,
  });

  final String name;
  final String price;
  final String description;
  final String? imageUrl;
  final int quantityInCart;
  final VoidCallback onAdd;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.03),
            blurRadius: 10,
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl!,
                          width: 76.w,
                          height: 76.w,
                          fit: BoxFit.cover,
                        )
                      : AppAssetImage(
                          assetPath: Assets.images.productImage,
                          width: 76.w,
                          height: 76.w,
                          fit: BoxFit.cover,
                          fallbackIcon: Icons.fastfood_rounded,
                        ),
                ),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(2.h),
                      Text(
                        description,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gap(6.h),
                      Text(
                        price,
                        style: AppTextStyles.price.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(8.w),
                _buildCartControl(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartControl() {
    if (quantityInCart == 0) {
      return IconButton(
        icon: Icon(
          Icons.add_circle_rounded,
          color: AppColors.primary,
          size: 30.sp,
        ),
        onPressed: onAdd,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onIncrement,
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Icon(
                Icons.add_rounded,
                color: AppColors.primary,
                size: 18.sp,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Text(
              '$quantityInCart',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          GestureDetector(
            onTap: onDecrement,
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Icon(
                Icons.remove_rounded,
                color: AppColors.primary,
                size: 18.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
