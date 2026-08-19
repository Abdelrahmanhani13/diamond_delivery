import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

/// Order cancelled result screen redesigned with premium visuals.
class OrderCancelledView extends StatelessWidget {
  const OrderCancelledView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Redesigned cancellation circle
                Container(
                  width: 130.w,
                  height: 130.w,
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.cancel_outlined,
                      size: 70.sp,
                      color: AppColors.warning,
                    ),
                  ),
                ).animate().scale(begin: const Offset(0.4, 0.4), end: const Offset(1, 1), duration: 500.ms, curve: Curves.easeOutBack),
                
                Gap(28.h),
                
                Text(
                  'تم إلغاء الطلب بنجاح',
                  style: AppTextStyles.headingLarge.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms),
                
                Gap(8.h),
                
                Text(
                  'لقد تم إلغاء طلبك رقم #10234 بنجاح. إذا كان هذا الإجراء غير مقصود أو واجهت مشكلة، تواصل معنا.',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 350.ms),
                
                Gap(36.h),
                
                // Reorder action
                AppButton(
                  label: 'العودة للتسوق والشراء',
                  icon: Icons.shopping_bag_outlined,
                  onPressed: () => context.go(AppRoutes.home),
                ).animate().fadeIn(delay: 450.ms),
                
                Gap(12.h),
                
                // Contact support
                AppButton(
                  label: 'التواصل الفوري مع الدعم',
                  variant: AppButtonVariant.outline,
                  icon: Icons.headset_mic_outlined,
                  onPressed: () => context.push(AppRoutes.contactSupport),
                ).animate().fadeIn(delay: 550.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
