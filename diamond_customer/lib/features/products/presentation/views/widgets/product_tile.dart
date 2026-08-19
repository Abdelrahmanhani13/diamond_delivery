import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/assets.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_asset_image.dart';
import '../../../domain/entities/product.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.product,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onTap,
  });

  final Product product;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final currency = context.tr('currency');
    final displayPrice = (product.discountPrice ?? product.price).toStringAsFixed(0);

    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
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
                  child: product.imageUrls.isNotEmpty
                      ? Image.network(
                          product.imageUrls.first,
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
                        product.name,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.textPrimaryColor,
                        ),
                      ),
                      Gap(2.h),
                      Text(
                        product.description,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: context.textSecondaryColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gap(6.h),
                      Text(
                        '$displayPrice $currency',
                        style: AppTextStyles.price.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.primaryThemeColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(8.w),
                _buildCartControl(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartControl(BuildContext context) {
    if (quantity == 0) {
      return IconButton(
        icon: Icon(
          Icons.add_circle_rounded,
          color: context.primaryThemeColor,
          size: 30.sp,
        ),
        onPressed: onIncrement,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: context.primaryThemeColor.withValues(alpha: 0.15),
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
                color: context.primaryThemeColor,
                size: 18.sp,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Text(
              '$quantity',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: context.primaryThemeColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: onDecrement,
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Icon(
                Icons.remove_rounded,
                color: context.primaryThemeColor,
                size: 18.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
