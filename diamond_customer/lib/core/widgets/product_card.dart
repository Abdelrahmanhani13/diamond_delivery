import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../localization/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_radius.dart';
import '../../features/products/domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.onTap});

  final Product product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final currency = context.tr('currency');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        width: 160.w,
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    color: context.greyLightColor,
                    child: product.imageUrls.isNotEmpty
                        ? Image.network(
                            product.imageUrls.first,
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            Icons.fastfood,
                            color: context.textSecondaryColor,
                            size: 50,
                          ),
                  ),
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: CircleAvatar(
                    backgroundColor: AppColors.white,
                    radius: 14.r,
                    child: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: AppColors.error,
                      size: 16.sp,
                    ),
                  ),
                ),
                if (!product.isAvailable)
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      child: Text(
                        'Out of Stock',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.textPrimaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    product.vendorName ?? '',
                    style: AppTextStyles.caption.copyWith(
                      color: context.textSecondaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.discountPrice != null)
                            Text(
                              '${product.price} $currency',
                              style: AppTextStyles.caption.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: context.textSecondaryColor,
                              ),
                            ),
                          Text(
                            '${product.discountPrice ?? product.price} $currency',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: context.primaryThemeColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.add_shopping_cart,
                        color: context.primaryThemeColor,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
