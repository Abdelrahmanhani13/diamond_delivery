import 'package:flutter/material.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';
import '../../data/models/vendor_dashboard_stats_model.dart';

class VendorDashboardStatsGrid extends StatelessWidget {
  final VendorDashboardStatsModel stats;

  const VendorDashboardStatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('إحصائيات المتجر', style: VendorTextStyles.headingSmall),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _StatCard(
              title: 'إجمالي المنتجات',
              value: stats.totalProducts.toString(),
              icon: Icons.inventory_2_outlined,
              color: VendorColors.primary,
            ),
            _StatCard(
              title: 'الطلبات الجديدة',
              value: stats.pendingOrders.toString(),
              icon: Icons.notifications_active_outlined,
              color: VendorColors.accent,
            ),
            _StatCard(
              title: 'قيد التجهيز',
              value: stats.preparingOrders.toString(),
              icon: Icons.soup_kitchen_outlined,
              color: Colors.orange,
            ),
            _StatCard(
              title: 'جاهزة للتسليم',
              value: stats.readyOrders.toString(),
              icon: Icons.check_circle_outline,
              color: VendorColors.success,
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: VendorColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: VendorColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: VendorTextStyles.bodySmall.copyWith(
                  color: VendorColors.textSecondary,
                ),
              ),
              Icon(icon, color: color, size: 22),
            ],
          ),
          Text(
            value,
            style: VendorTextStyles.headingLarge.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
