import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../../core/constants/app_radius.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/models/order_model.dart';
import 'order_status_chip.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.onDetails,
  });

  final OrderModel order;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    final dateStr = order.createdAt != null
        ? DateFormat('yyyy/MM/dd • hh:mm a').format(order.createdAt!)
        : '';
    final vendorName = order.vendorNameArabic?.isNotEmpty == true
        ? order.vendorNameArabic!
        : (order.vendorNameEnglish ?? 'المتجر');

    return AppCard(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: order.vendorLogoUrl != null && order.vendorLogoUrl!.isNotEmpty
                    ? Image.network(
                        order.vendorLogoUrl!,
                        width: 50.w,
                        height: 50.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.storefront_rounded),
                      )
                    : Container(
                        width: 50.w,
                        height: 50.w,
                        color: AppColors.greyLight,
                        child: const Icon(Icons.storefront_rounded, color: AppColors.primary),
                      ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendorName,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      'رقم الطلب: ${order.orderNumber}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (dateStr.isNotEmpty) ...[
                      Gap(2.h),
                      Text(
                        dateStr,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textHint,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              OrderStatusChip(status: order.orderStatus),
            ],
          ),

          Gap(12.h),
          const Divider(height: 1),
          Gap(12.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${order.total.toStringAsFixed(0)} ر.س',
                    style: AppTextStyles.headingSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (order.itemCount != null)
                    Text(
                      '${order.itemCount} عناصر',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
              AppButton(
                label: 'التفاصيل',
                height: 36.h,
                fullWidth: false,
                onPressed: onDetails,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
