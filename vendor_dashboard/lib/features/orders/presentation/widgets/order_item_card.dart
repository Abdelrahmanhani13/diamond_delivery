import 'package:flutter/material.dart';
import 'package:vendor_dashboard/core/theme/vendor_colors.dart';
import 'package:vendor_dashboard/core/theme/vendor_text_styles.dart';
import '../../domain/entities/vendor_order.dart';

class OrderItemCard extends StatelessWidget {
  final VendorOrder order;
  final VoidCallback onTap;
  final Function(String action)? onActionTap;
  final bool isActionLoading;

  const OrderItemCard({
    super.key,
    required this.order,
    required this.onTap,
    this.onActionTap,
    this.isActionLoading = false,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
      case 'pending':
        return Colors.orange;
      case 'preparing':
        return Colors.blue;
      case 'ready':
        return Colors.purple;
      case 'delivered':
      case 'completed':
        return VendorColors.success;
      case 'cancelled':
      case 'rejected':
        return VendorColors.error;
      default:
        return VendorColors.primary;
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'available':
      case 'pending':
        return 'طلب جديد';
      case 'preparing':
        return 'قيد التجهيز';
      case 'ready':
        return 'جاهز للتسليم';
      case 'delivered':
      case 'completed':
        return 'تم التسليم';
      case 'cancelled':
        return 'ملغي';
      case 'rejected':
        return 'مرفوض';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(order.orderStatus);
    final statusText = _statusLabel(order.orderStatus);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: VendorColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: VendorColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'رقم الطلب: #${order.orderNumber}',
                    style: VendorTextStyles.titleMedium,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText,
                      style: VendorTextStyles.bodySmall.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 18,
                    color: VendorColors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(order.customerName, style: VendorTextStyles.bodyMedium),
                  const Spacer(),
                  const Icon(
                    Icons.phone_outlined,
                    size: 18,
                    color: VendorColors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(order.customerPhone, style: VendorTextStyles.bodyMedium),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${order.itemCount} عناصر • ${order.paymentMethod}',
                    style: VendorTextStyles.bodySmall.copyWith(
                      color: VendorColors.grey,
                    ),
                  ),
                  Text(
                    '${order.total.toStringAsFixed(2)} جنيه',
                    style: VendorTextStyles.titleMedium.copyWith(
                      color: VendorColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (_hasActions(order.orderStatus) && onActionTap != null) ...[
                const Divider(height: 24),
                _buildActionButtons(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool _hasActions(String status) {
    final s = status.toLowerCase();
    return s == 'available' || s == 'pending' || s == 'preparing';
  }

  Widget _buildActionButtons(BuildContext context) {
    if (isActionLoading) {
      return const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    final s = order.orderStatus.toLowerCase();
    if (s == 'available' || s == 'pending') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: VendorColors.error,
                side: const BorderSide(color: VendorColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => onActionTap?.call('reject'),
              child: const Text('رفض'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: VendorColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => onActionTap?.call('accept'),
              child: const Text('قبول'),
            ),
          ),
        ],
      );
    } else if (s == 'preparing') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => onActionTap?.call('ready'),
          child: const Text('تعليم كجاهز للتسليم'),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
