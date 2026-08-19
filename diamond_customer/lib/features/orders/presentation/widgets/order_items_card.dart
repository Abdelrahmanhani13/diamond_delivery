import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/localization/app_localizations.dart';
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
    final currency = context.tr('currency');

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('items'),
            style: AppTextStyles.headingSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: context.textPrimaryColor,
            ),
          ),
          Gap(14.h),
          if (items.isEmpty)
            Text(
              context.tr('noOrdersYet'),
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.textSecondaryColor,
              ),
            )
          else
            ...items.map((item) => _itemRow(
                  context,
                  item.productName,
                  '× ${item.quantity}',
                  '${item.totalPrice.toStringAsFixed(0)} $currency',
                )),
          const Divider(height: 24),
          if (subtotal != null)
            _itemRow(context, context.tr('subtotal'), '', '${subtotal!.toStringAsFixed(0)} $currency'),
          if (deliveryFee != null)
            _itemRow(context, context.tr('deliveryFee'), '', '${deliveryFee!.toStringAsFixed(0)} $currency'),
          _itemRow(context, context.tr('total'), '', '${total.toStringAsFixed(0)} $currency', bold: true),
        ],
      ),
    );
  }

  Widget _itemRow(BuildContext context, String name, String qty, String price, {bool bold = false}) {
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
                    ? context.textPrimaryColor
                    : context.textPrimaryColor.withValues(alpha: 0.9),
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (qty.isNotEmpty)
            Text(
              qty,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: context.textPrimaryColor,
              ),
            ),
          Gap(16.w),
          Text(
            price,
            style: style.copyWith(
              fontWeight: bold ? FontWeight.w900 : FontWeight.bold,
              color: bold ? context.primaryThemeColor : context.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
