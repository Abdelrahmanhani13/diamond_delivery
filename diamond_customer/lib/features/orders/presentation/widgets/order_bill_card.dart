import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';

/// A card showing a breakdown of order items and pricing.
class OrderBillCard extends StatelessWidget {
  const OrderBillCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تفاصيل الفاتورة',
            style: AppTextStyles.headingSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(12.h),
          _BillRow(label: 'برجر لحم مزدوج سوبريم × 2', value: '60 ر.س'),
          _BillRow(label: 'بطاطس مقلية بالجبنة × 1', value: '12 ر.س'),
          _BillRow(label: 'رسوم التوصيل المعتادة', value: '10 ر.س'),
          const Divider(height: 20),
          _BillRow(
            label: 'الإجمالي المستحق الدفع',
            value: '82 ر.س',
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _BillRow extends StatelessWidget {
  const _BillRow({required this.label, required this.value, this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = bold ? AppTextStyles.bodyLarge : AppTextStyles.bodyMedium;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: style.copyWith(
              color: bold
                  ? AppColors.textPrimary
                  : AppColors.textPrimary.withValues(alpha: 0.9),
            ),
          ),
          Text(
            value,
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
