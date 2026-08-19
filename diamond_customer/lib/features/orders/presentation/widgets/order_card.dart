import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../../core/constants/app_radius.dart';
import '../../../../core/localization/app_localizations.dart';
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
    this.onTap,
  });

  final OrderModel order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final currency = context.tr('currency');
    final dateStr = order.createdAt != null
        ? DateFormat('yyyy/MM/dd • hh:mm a').format(order.createdAt!)
        : '';
    final vendorName = context.localizedText(order.vendorNameArabic, order.vendorNameEnglish);

    return AppCard(
      onTap: onTap,
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
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.storefront_rounded,
                          color: context.primaryThemeColor,
                        ),
                      )
                    : Container(
                        width: 50.w,
                        height: 50.w,
                        color: context.greyLightColor,
                        child: Icon(
                          Icons.storefront_rounded,
                          color: context.primaryThemeColor,
                        ),
                      ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendorName.isNotEmpty ? vendorName : 'Vendor',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.textPrimaryColor,
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      '${context.tr('orderNumber')}: ${order.orderNumber}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: context.textSecondaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (dateStr.isNotEmpty) ...[
                      Gap(2.h),
                      Text(
                        dateStr,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: context.textSecondaryColor,
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
                    '${order.total.toStringAsFixed(0)} $currency',
                    style: AppTextStyles.headingSmall.copyWith(
                      color: context.primaryThemeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (order.itemCount != null)
                    Text(
                      '${order.itemCount} ${context.tr('items')}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: context.textSecondaryColor,
                      ),
                    ),
                ],
              ),
              AppButton(
                label: context.tr('orderDetails'),
                height: 36.h,
                fullWidth: false,
                onPressed: onTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
