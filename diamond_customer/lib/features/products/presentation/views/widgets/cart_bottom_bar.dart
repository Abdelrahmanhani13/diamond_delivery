import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class CartBottomBar extends StatelessWidget {
  const CartBottomBar({
    super.key,
    required this.totalItems,
    required this.totalPrice,
    required this.onViewCart,
  });

  final int totalItems;
  final double totalPrice;
  final VoidCallback onViewCart;

  @override
  Widget build(BuildContext context) {
    final currency = context.tr('currency');

    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${context.tr('items')}: $totalItems',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),
                Text(
                  '${context.tr('total')}: $totalPrice $currency',
                  style: AppTextStyles.headingSmall.copyWith(
                    color: context.primaryThemeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryThemeColor,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 12.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              onPressed: onViewCart,
              icon: const Icon(Icons.shopping_bag_outlined),
              label: Text(
                context.tr('cart'),
                style: AppTextStyles.buttonMedium,
              ),
            ),
          ],
        ),
      ),
    ).animate().slideY(
          begin: 1,
          end: 0,
          duration: 300.ms,
          curve: Curves.easeOutCubic,
        );
  }
}
