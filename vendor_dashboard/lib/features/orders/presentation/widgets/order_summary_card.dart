import 'package:flutter/material.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';
import '../../../../core/utils/localized_entity_extension.dart';
import '../../domain/entities/vendor_order.dart';

class OrderSummaryCard extends StatelessWidget {
  final VendorOrder order;

  const OrderSummaryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VendorColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('financialsSection'),
            style: VendorTextStyles.titleMedium,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.tr('subtotal'), style: VendorTextStyles.bodyMedium),
              Text(
                '${order.subTotal.toStringAsFixed(2)} JOD',
                style: VendorTextStyles.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('deliveryFee'),
                style: VendorTextStyles.bodyMedium,
              ),
              Text(
                '${order.deliveryFee.toStringAsFixed(2)} JOD',
                style: VendorTextStyles.bodyMedium,
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('grandTotal'),
                style: VendorTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${order.totalAmount.toStringAsFixed(2)} JOD',
                style: VendorTextStyles.titleLarge.copyWith(
                  color: VendorColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
