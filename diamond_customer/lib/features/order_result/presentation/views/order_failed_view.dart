import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

/// Order failed screen — redesigned with premium warning containers and clean actions.
class OrderFailedView extends StatelessWidget {
  const OrderFailedView({super.key, this.reason = 'تعذر إتمام عملية الدفع وتأكيد طلبك، يرجى إعادة المحاولة.'});

  final String reason;

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
                // Redesigned error circle
                Container(
                  width: 130.w,
                  height: 130.w,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.error_outline_rounded,
                      size: 70.sp,
                      color: AppColors.error,
                    ),
                  ),
                ).animate().shake(duration: 500.ms),
                
                Gap(28.h),
                
                Text(
                  'لم نتمكن من إتمام طلبك',
                  style: AppTextStyles.headingLarge.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms),
                
                Gap(8.h),
                
                Text(
                  reason,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 350.ms),
                
                Gap(36.h),
                
                // Retry action
                AppButton(
                  label: 'إعادة المحاولة',
                  icon: Icons.refresh_rounded,
                  onPressed: () => context.pop(),
                ).animate().fadeIn(delay: 450.ms),
                
                Gap(12.h),
                
                // Contact support
                AppButton(
                  label: 'تواصل مع الدعم الفني',
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
