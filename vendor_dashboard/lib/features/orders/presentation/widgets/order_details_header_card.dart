import 'package:flutter/material.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';
import '../../../../core/utils/localized_entity_extension.dart';
import '../../domain/entities/vendor_order.dart';

class OrderDetailsHeaderCard extends StatelessWidget {
  final VendorOrder order;

  const OrderDetailsHeaderCard({super.key, required this.order});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${context.tr('orderNumber')} #${order.orderNumber}',
                style: VendorTextStyles.titleMedium,
              ),
              _StatusChip(status: order.orderStatus),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${context.tr('orderDate')}: ${order.createdAtFormatted}',
            style: VendorTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status.toLowerCase()) {
      case 'available':
      case 'pending':
        bg = VendorColors.accent.withValues(alpha: 0.15);
        fg = VendorColors.accent;
        label = context.tr('statusNew');
        break;
      case 'preparing':
        bg = Colors.orange.withValues(alpha: 0.15);
        fg = Colors.orange;
        label = context.tr('statusPreparing');
        break;
      case 'ready':
        bg = VendorColors.primary.withValues(alpha: 0.15);
        fg = VendorColors.primary;
        label = context.tr('statusReady');
        break;
      case 'delivered':
      case 'completed':
        bg = VendorColors.success.withValues(alpha: 0.15);
        fg = VendorColors.success;
        label = context.tr('statusCompleted');
        break;
      case 'rejected':
      case 'cancelled':
        bg = VendorColors.error.withValues(alpha: 0.15);
        fg = VendorColors.error;
        label = context.tr('statusCancelled');
        break;
      default:
        bg = VendorColors.greyLight;
        fg = VendorColors.textSecondary;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
