import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../widgets/tracking_map_card.dart';
import '../widgets/courier_info_card.dart';
import '../widgets/delivery_address_card.dart';
import '../widgets/order_bill_card.dart';

/// Live order tracking screen featuring a premium vector simulated route
/// tracking map, detailed milestone progress, courier dashboard, and
/// financial summary.
class OrderTrackingView extends StatelessWidget {
  const OrderTrackingView({super.key, this.activeStage = 6});

  final int activeStage;

  @override
  Widget build(BuildContext context) {
    // final steps = OrderStatusTimeline.fullDeliveryStages(
    //   activeIndex: activeStage,
    // );

    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'تتبع السائق والطلب #10234',
        onBack: () => context.go(AppRoutes.orders),
      ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          children: [
            // Styled Vector Tracking Map card
            const TrackingMapCard().animate().fadeIn(duration: 300.ms),

            Gap(14.h),

            // Courier information card
            const CourierInfoCard().animate().fadeIn(
              delay: 100.ms,
              duration: 350.ms,
            ),

            Gap(14.h),

            // Live stages timeline progress card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مراحل التوصيل والتحضير',
                    style: AppTextStyles.headingSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(16.h),
                  // OrderStatusTimeline(steps: steps),
                ],
              ),
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

            Gap(14.h),

            // Destination Delivery Address card
            const DeliveryAddressCard().animate().fadeIn(
              delay: 200.ms,
              duration: 400.ms,
            ),

            Gap(14.h),

            // Financial pricing bill breakdown
            const OrderBillCard().animate().fadeIn(
              delay: 250.ms,
              duration: 400.ms,
            ),

            Gap(24.h),

            // Re-route details option button
            AppButton(
              label: 'تفاصيل الطلب والفواتير',
              variant: AppButtonVariant.outline,
              icon: Icons.receipt_long_outlined,
              onPressed: () => context.push(AppRoutes.orderDetails),
            ),
          ],
        ),
      );
  }
}
