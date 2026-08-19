import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key, this.orderNumber = '10234'});

  final String orderNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 140.w,
                height: 140.w,
                decoration: BoxDecoration(
                  color: context.primaryThemeColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: context.primaryThemeColor.withValues(alpha: 0.1),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 80.sp,
                    color: context.primaryThemeColor,
                  ),
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.3, 0.3),
                    end: const Offset(1.0, 1.0),
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  )
                  .then()
                  .shake(duration: 350.ms),

              Gap(36.h),

              Text(
                context.tr('orderSuccess'),
                style: AppTextStyles.headingLarge.copyWith(
                  fontWeight: FontWeight.w900,
                  color: context.textPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.15, end: 0, duration: 400.ms),

              Gap(10.h),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: context.primaryThemeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${context.tr('orderNumber')}: #$orderNumber',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: context.primaryThemeColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ).animate().fadeIn(delay: 350.ms),

              Gap(12.h),

              Text(
                context.isArabic
                    ? 'الوصول المتوقع خلال 25-35 دقيقة تقريباً\nيمكنك متابعة حالة السائق الآن.'
                    : 'Expected arrival in 25-35 minutes.\nYou can track your order status now.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: context.textSecondaryColor,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 500.ms),

              Gap(40.h),

              AppButton(
                label: context.isArabic ? 'تتبع حالة السائق والطلب' : 'Track Order Status',
                icon: Icons.local_shipping_outlined,
                onPressed: () => context.pushReplacement(AppRoutes.orderTracking),
              ).animate().fadeIn(delay: 600.ms),

              Gap(12.h),

              AppButton(
                label: context.tr('home'),
                variant: AppButtonVariant.outline,
                icon: Icons.home_outlined,
                onPressed: () => context.go(AppRoutes.home),
              ).animate().fadeIn(delay: 700.ms),
            ],
          ),
        ),
      ),
    );
  }
}
