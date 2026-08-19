import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/widgets/app_button.dart';

/// Inline feature callout card, e.g. "صيدليات الآن — توصيل خلال 30 دقيقة"
/// used to promote the Medicine Request flow from Home.
class FeaturePromoCard extends StatelessWidget {
  const FeaturePromoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.ctaLabel,
    this.onTap,
    required this.image,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String ctaLabel;
  final VoidCallback? onTap;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: ClipOval(child: Image.asset(image, fit: BoxFit.cover)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.headingSmall.copyWith(
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          AppButton(
            label: ctaLabel,
            variant: AppButtonVariant.secondary,
            fullWidth: false,
            height: 36.h,
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}
