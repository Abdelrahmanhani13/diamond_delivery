import 'package:flutter/material.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';
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
          Text('ملخص الحساب', style: VendorTextStyles.titleMedium),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('المجموع الفرعي', style: VendorTextStyles.bodyMedium),
              Text(
                '${order.subTotal.toStringAsFixed(2)} د.أ',
                style: VendorTextStyles.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('رسوم التوصيل', style: VendorTextStyles.bodyMedium),
              Text(
                '${order.deliveryFee.toStringAsFixed(2)} د.أ',
                style: VendorTextStyles.bodyMedium,
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المجموع الكلي',
                style: VendorTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${order.totalAmount.toStringAsFixed(2)} د.أ',
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
