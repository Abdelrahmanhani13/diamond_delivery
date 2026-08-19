import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_radius.dart';

class OrderSummaryWidget extends StatelessWidget {
  const OrderSummaryWidget({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    this.discount = 0,
    required this.total,
  });

  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;

  @override
  Widget build(BuildContext context) {
    final currency = context.tr('currency');

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('orderDetails'),
            style: AppTextStyles.headingSmall.copyWith(
              color: context.textPrimaryColor,
            ),
          ),
          SizedBox(height: 12.h),
          _row(context, context.tr('subtotal'), '${subtotal.toStringAsFixed(0)} $currency'),
          _row(context, context.tr('deliveryFee'), '${deliveryFee.toStringAsFixed(0)} $currency'),
          if (discount > 0)
            _row(context, 'الخصم', '- ${discount.toStringAsFixed(0)} $currency', color: AppColors.success),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: const Divider(height: 1),
          ),
          _row(context, context.tr('total'), '${total.toStringAsFixed(0)} $currency', bold: true),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value, {bool bold = false, Color? color}) {
    final textColor = color ?? context.textPrimaryColor;
    final style = (bold ? AppTextStyles.bodyLarge : AppTextStyles.bodyMedium).copyWith(color: textColor);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(
            value,
            style: style.copyWith(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
