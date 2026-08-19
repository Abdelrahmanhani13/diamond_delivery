import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_radius.dart';

/// Price breakdown card used in Cart and Checkout (subtotal, delivery,
/// discount, total).
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
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ملخص الطلب', style: AppTextStyles.headingSmall),
          SizedBox(height: 12.h),
          _row('المجموع الفرعي', '${subtotal.toStringAsFixed(0)} ر.س'),
          _row('رسوم التوصيل', '${deliveryFee.toStringAsFixed(0)} ر.س'),
          if (discount > 0) _row('الخصم', '- ${discount.toStringAsFixed(0)} ر.س', color: AppColors.success),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: const Divider(height: 1),
          ),
          _row('الإجمالي', '${total.toStringAsFixed(0)} ر.س', bold: true),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false, Color? color}) {
    final style = bold ? AppTextStyles.bodyLarge : AppTextStyles.bodyMedium;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(
            value,
            style: style.copyWith(fontWeight: bold ? FontWeight.w700 : FontWeight.w600, color: color ?? style.color),
          ),
        ],
      ),
    );
  }
}
