import 'package:flutter/material.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';
import '../../domain/entities/vendor_order.dart';

class OrderCustomerInfoCard extends StatelessWidget {
  final VendorOrder order;

  const OrderCustomerInfoCard({super.key, required this.order});

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
          Text('معلومات العميل', style: VendorTextStyles.titleMedium),
          const SizedBox(height: 12),
          if (order.customerName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 18,
                    color: VendorColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    order.customerName,
                    style: VendorTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          if (order.customerPhone.isNotEmpty)
            Row(
              children: [
                const Icon(
                  Icons.phone_outlined,
                  size: 18,
                  color: VendorColors.primary,
                ),
                const SizedBox(width: 8),
                Text(order.customerPhone, style: VendorTextStyles.bodyMedium),
              ],
            ),
        ],
      ),
    );
  }
}
