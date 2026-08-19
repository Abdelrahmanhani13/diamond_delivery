import 'package:diamond_customer/core/constants/app_radius.dart';
import 'package:diamond_customer/core/constants/assets.dart';
import 'package:diamond_customer/core/localization/app_localizations.dart';
import 'package:diamond_customer/core/theme/app_colors.dart';
import 'package:diamond_customer/core/theme/app_text_styles.dart';
import 'package:diamond_customer/features/products/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.onTap});

  final Product product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasDiscount =
        product.discountPrice != null && product.discountPrice! < product.price;
    final displayPrice = product.discountPrice ?? product.price;
    final currency = context.tr('currency');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Opacity(
        opacity: product.isAvailable ? 1 : 0.5,
        child: Container(
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
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
                    aspectRatio: 16 / 9,
                    child: Container(
                      color: context.greyLightColor,
                      child: product.imageUrls.isNotEmpty
                          ? Image.network(
                              product.imageUrls.first,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Image.asset(
                                Assets.images.productImage,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              Assets.images.productImage,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  if (hasDiscount)
                    Positioned(
                      top: 10.h,
                      right: 10.w,
                      child: _Badge(
                        label:
                            '${(100 - (product.discountPrice! / product.price * 100)).round()}%',
                        color: AppColors.accent,
                      ),
                    ),
                  if (!product.isAvailable)
                    Positioned(
                      top: 10.h,
                      left: 10.w,
                      child: _Badge(
                        label: context.isArabic ? 'غير متاح' : 'Unavailable',
                        color: AppColors.textHint,
                      ),
                    ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 16.sp,
                          color: AppColors.rating,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      product.name,
                      style: AppTextStyles.headingSmall.copyWith(
                        color: context.textPrimaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      product.vendorName ?? '',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: context.textSecondaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        if (hasDiscount) ...[
                          Text(
                            '${product.price} $currency',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: context.textSecondaryColor,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(width: 6.w),
                        ],
                        Text(
                          '$displayPrice $currency',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.primaryThemeColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: AppColors.white),
      ),
    );
  }
}
