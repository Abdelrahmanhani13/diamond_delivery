import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/models/order_item_model.dart';

class OrderItemsCard extends StatelessWidget {
  const OrderItemsCard({
    super.key,
    required this.items,
    this.subtotal,
    this.deliveryFee,
    required this.total,
  });

  final List<OrderItemModel> items;
  final double? subtotal;
  final double? deliveryFee;
  final double total;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'عناصر الطلب (لقطة الطلب التاريخية)',
            style: AppTextStyles.headingSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(14.h),
          if (items.isEmpty)
            Text('لا توجد تفاصيل عناصر مسبقة', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint))
          else
            ...items.map((item) => _itemRow(
                  item.productName,
                  '× ${item.quantity}',
                  '${item.totalPrice.toStringAsFixed(0)} ر.س',
                )),
          const Divider(height: 24),
          if (subtotal != null)
            _itemRow('المجموع الفرعي', '', '${subtotal!.toStringAsFixed(0)} ر.س'),
          if (deliveryFee != null)
            _itemRow('رسوم التوصيل', '', '${deliveryFee!.toStringAsFixed(0)} ر.س'),
          _itemRow('الإجمالي النهائى', '', '${total.toStringAsFixed(0)} ر.س', bold: true),
        ],
      ),
    );
  }

  Widget _itemRow(String name, String qty, String price, {bool bold = false}) {
    final style = bold ? AppTextStyles.bodyLarge : AppTextStyles.bodyMedium;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: style.copyWith(
                color: bold
                    ? AppColors.textPrimary
                    : AppColors.textPrimary.withValues(alpha: 0.9),
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (qty.isNotEmpty)
            Text(
              qty,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          Gap(16.w),
          Text(
            price,
            style: style.copyWith(
              fontWeight: bold ? FontWeight.w900 : FontWeight.bold,
              color: bold ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
