import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/order_model.dart';

class OrderStatusTimeline extends StatelessWidget {
  const OrderStatusTimeline({
    super.key,
    required this.orderStatus,
  });

  final String orderStatus;

  static const List<Map<String, String>> _flowSteps = [
    {'key': 'Pending', 'label': 'قيد الانتظار'},
    {'key': 'Accepted', 'label': 'تم القبول'},
    {'key': 'Preparing', 'label': 'جاري التجهيز'},
    {'key': 'ReadyForDelivery', 'label': 'جاهز للتوصيل'},
    {'key': 'OutForDelivery', 'label': 'جاري التوصيل'},
    {'key': 'Delivered', 'label': 'تم التوصيل'},
  ];

  @override
  Widget build(BuildContext context) {
    final status = orderStatus.toOrderStatus;

    if (status == BackendOrderStatus.cancelled || status == BackendOrderStatus.rejected) {
      final isCancelled = status == BackendOrderStatus.cancelled;
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.cancel_outlined, color: AppColors.error, size: 24.sp),
            Gap(12.w),
            Text(
              isCancelled ? 'تم إلغاء هذا الطلب' : 'تم رفض هذا الطلب من قبل المتجر',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    int activeIndex = 0;
    switch (orderStatus.toLowerCase()) {
      case 'pending':
        activeIndex = 0;
        break;
      case 'accepted':
        activeIndex = 1;
        break;
      case 'preparing':
        activeIndex = 2;
        break;
      case 'readyfordelivery':
        activeIndex = 3;
        break;
      case 'outfordelivery':
        activeIndex = 4;
        break;
      case 'delivered':
        activeIndex = 5;
        break;
      default:
        activeIndex = 0;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(_flowSteps.length * 2 - 1, (index) {
            if (index.isEven) {
              final stepIndex = index ~/ 2;
              final isActive = stepIndex <= activeIndex;

              return Container(
                width: 14.w,
                height: 14.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? AppColors.primary : AppColors.greyLight,
                  border: Border.all(
                    color: isActive ? AppColors.primary : AppColors.greyLight,
                    width: 2,
                  ),
                ),
                child: isActive
                    ? Icon(Icons.check, size: 8.sp, color: AppColors.white)
                    : null,
              );
            } else {
              final previousStepIndex = index ~/ 2;
              final isActive = previousStepIndex < activeIndex;

              return Expanded(
                child: Container(
                  height: 2.h,
                  color: isActive ? AppColors.primary : AppColors.greyLight,
                ),
              );
            }
          }),
        ),
        Gap(8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _flowSteps.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final isActive = idx <= activeIndex;

            return Expanded(
              child: Text(
                item['label']!,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 10.sp,
                  color: isActive ? AppColors.textPrimary : AppColors.textHint,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
