import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

/// Full-screen "no internet connection" state.
class NoInternetView extends StatelessWidget {
  const NoInternetView({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 110.w,
                  height: 110.w,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.wifi_off_rounded,
                    size: 50.sp,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'لا يوجد اتصال بالإنترنت',
                  style: AppTextStyles.headingMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى',
                  style: AppTextStyles.bodySmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 28.h),
                AppButton(
                  label: 'إعادة المحاولة',
                  onPressed: onRetry,
                  icon: Icons.refresh_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
