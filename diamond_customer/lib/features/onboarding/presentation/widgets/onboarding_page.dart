import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class OnboardingPageData {
  const OnboardingPageData({required this.icon, required this.title, required this.description});
  final IconData icon;
  final String title;
  final String description;
}

/// Single onboarding slide. TODO: swap the icon illustration placeholder
/// for Assets.images.onboarding{n} once real artwork is supplied.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key, required this.data});

  final OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 220.w,
            height: 220.w,
            decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
            child: Icon(data.icon, size: 90.sp, color: AppColors.primary),
          ),
          SizedBox(height: 40.h),
          Text(data.title, style: AppTextStyles.headingLarge, textAlign: TextAlign.center),
          SizedBox(height: 12.h),
          Text(data.description, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
