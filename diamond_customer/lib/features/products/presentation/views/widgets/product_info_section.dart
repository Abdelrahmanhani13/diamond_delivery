import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/product_card.dart';
import '../../../../cart/presentation/widgets/quantity_selector.dart';
import '../../../domain/entities/product.dart';

class ProductInfoSection extends StatelessWidget {
  const ProductInfoSection({
    super.key,
    required this.product,
    required this.relatedProducts,
    required this.price,
    required this.quantity,
    required this.onQuantityIncrement,
    required this.onQuantityDecrement,
  });

  final Product product;
  final List<Product> relatedProducts;
  final double price;
  final int quantity;
  final VoidCallback onQuantityIncrement;
  final VoidCallback onQuantityDecrement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: AppTextStyles.headingLarge.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              QuantitySelector(
                quantity: quantity,
                onIncrement: onQuantityIncrement,
                onDecrement: onQuantityDecrement,
              ),
            ],
          ),
          
          SizedBox(height: 8.h),
          
          // Rating & Reviews Count
          Row(
            children: [
              Icon(Icons.star_rounded, size: 18.sp, color: AppColors.rating),
              SizedBox(width: 4.w),
              Text(
                '${product.rating}',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Price tag
          Row(
            children: [
              if (product.discountPrice != null) ...[
                Text(
                  '${product.price} ر.س',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.textHint,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                SizedBox(width: 8.w),
              ],
              Text(
                '$price ر.س',
                style: AppTextStyles.displayLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          Text(
            product.description,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.6),
          ),
          
          SizedBox(height: 28.h),
          
          if (relatedProducts.isNotEmpty) ...[
            const SectionHeader(title: 'منتجات مشابهة'),
            SizedBox(height: 14.h),
            SizedBox(
              height: 220.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: relatedProducts.length,
                separatorBuilder: (context, index) => SizedBox(width: 12.w),
                itemBuilder: (context, index) => ProductCard(
                  product: relatedProducts[index],
                  onTap: () => context.push(AppRoutes.productDetails, extra: relatedProducts[index].id),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
