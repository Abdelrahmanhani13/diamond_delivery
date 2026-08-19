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

/// Rate the order quality after delivery with premium star selectors
/// and micro bounce feedback animations.
class RateOrderView extends StatefulWidget {
  const RateOrderView({super.key});

  @override
  State<RateOrderView> createState() => _RateOrderViewState();
}

class _RateOrderViewState extends State<RateOrderView> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: const CustomAppBar(title: 'تقييم جودة الوجبات'),
        body: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          child: Column(
            children: [
              AppCard(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.restaurant_rounded, size: 28.sp, color: AppColors.primary),
                    ),
                    Gap(16.h),
                    Text(
                      'كيف كان وجبتك من برجر هاوس؟',
                      style: AppTextStyles.headingMedium.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Gap(8.h),
                    Text(
                      'رأيك يهمنا لتحسين جودة تحضير الطعام وتغليفه.',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    Gap(24.h),
                    
                    // Star rating row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) {
                        final isSelected = i < _rating;
                        return GestureDetector(
                          onTap: () => setState(() => _rating = i + 1),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: Icon(
                              isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                              size: 44.sp,
                              color: AppColors.rating,
                            )
                                .animate(target: isSelected ? 1 : 0)
                                .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 150.ms, curve: Curves.bounceOut)
                                .then()
                                .scale(begin: const Offset(1.2, 1.2), end: const Offset(1, 1), duration: 150.ms),
                          ),
                        );
                      }),
                    ),
                    
                    Gap(16.h),
                    Text(
                      _rating == 0 ? 'اضغط على النجوم للتقييم' : _ratingLabel(_rating),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: _rating == 0 ? AppColors.textHint : AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Proceed button
              AppButton(
                label: 'متابعة تقييم مندوب التوصيل',
                icon: Icons.arrow_back_rounded,
                onPressed: _rating > 0 ? () => context.push(AppRoutes.rateDriver) : null,
              ),
              
              Gap(10.h),
              
              AppButton(
                label: 'تخطي التقييم',
                variant: AppButtonVariant.text,
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _ratingLabel(int r) => switch (r) {
        1 => 'سيء جداً 😞',
        2 => 'سيء 🙁',
        3 => 'مقبول 😐',
        4 => 'جيد جداً 🙂',
        _ => 'ممتاز ورائع! 😍',
      };
}
