import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_radius.dart';
import '../../data/models/cart_item_model.dart';
import 'quantity_selector.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final CartItemModel item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final currency = context.tr('currency');
    final name = context.localizedText(item.nameArabic, item.nameEnglish);

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: !item.isAvailable
            ? Border.all(color: AppColors.error.withValues(alpha: 0.4))
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: item.primaryImageUrl != null && item.primaryImageUrl!.isNotEmpty
                ? Image.network(
                    item.primaryImageUrl!,
                    width: 72.w,
                    height: 72.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 72.w,
                      height: 72.w,
                      color: context.greyLightColor,
                      child: Icon(Icons.fastfood_rounded, color: context.textSecondaryColor),
                    ),
                  )
                : Container(
                    width: 72.w,
                    height: 72.w,
                    color: context.greyLightColor,
                    child: Icon(Icons.fastfood_rounded, color: context.textSecondaryColor),
                  ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.textPrimaryColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                if (!item.isAvailable)
                  Text(
                    'المنتج غير متاح حالياً',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else if (item.stockQuantity > 0 && item.stockQuantity <= 5)
                  Text(
                    'متبقي ${item.stockQuantity} فقط في المخزون',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.warning,
                    ),
                  ),
                SizedBox(height: 6.h),
                Text(
                  '${item.unitPrice.toStringAsFixed(0)} $currency  (${context.tr('total')}: ${item.itemTotal.toStringAsFixed(0)} $currency)',
                  style: AppTextStyles.price.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                    color: context.primaryThemeColor,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onRemove,
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 20.sp,
                  color: AppColors.error,
                ),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Gap(12.h),
              QuantitySelector(
                quantity: item.quantity,
                onIncrement: onIncrement,
                onDecrement: onDecrement,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
