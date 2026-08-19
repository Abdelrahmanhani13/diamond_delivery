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
import '../../../cart/presentation/widgets/order_summary_widget.dart';

/// Review order details screen before final placement.
/// Redesigned to look premium and aligned.
class ReviewOrderView extends StatelessWidget {
  const ReviewOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: const CustomAppBar(title: 'مراجعة وتثبيت الطلب'),
        body: ListView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          children: [
            // Instruction warning banner
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.2), width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: AppColors.accent, size: 20.sp),
                  Gap(10.w),
                  Expanded(
                    child: Text(
                      'يرجى التأكد من تفاصيل التوصيل والملخص المالي قبل التأكيد.',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),

            Gap(16.h),

            // Delivery Address card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('عنوان التوصيل المختار', style: AppTextStyles.headingSmall.copyWith(fontWeight: FontWeight.bold)),
                  Gap(10.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20.sp),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: Text(
                          'المنزل — حي النرجس، شارع 900، الرياض',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 350.ms),

            Gap(12.h),

            // Payment Method card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('طريقة الدفع المحددة', style: AppTextStyles.headingSmall.copyWith(fontWeight: FontWeight.bold)),
                  Gap(10.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.money_rounded, color: AppColors.primary, size: 20.sp),
                      ),
                      Gap(12.w),
                      Text(
                        'نقداً عند الاستلام',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 150.ms, duration: 350.ms),

            Gap(12.h),

            // Products details card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الملخص والمشتريات', style: AppTextStyles.headingSmall.copyWith(fontWeight: FontWeight.bold)),
                  Gap(12.h),
                  _row('برجر لحم مزدوج سوبريم × 2', '60 ر.س'),
                  const Divider(height: 16),
                  _row('بطاطس مقلية بالجبنة × 1', '12 ر.س'),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

            Gap(12.h),

            // Bill Summary Widget card
            const OrderSummaryWidget(
              subtotal: 72,
              deliveryFee: 10,
              total: 82,
            ).animate().fadeIn(delay: 250.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: AppButton(
              label: 'إرسال وتأكيد الطلب • 82 ر.س',
              icon: Icons.check_circle_rounded,
              onPressed: () => context.go(AppRoutes.orderSuccess),
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
