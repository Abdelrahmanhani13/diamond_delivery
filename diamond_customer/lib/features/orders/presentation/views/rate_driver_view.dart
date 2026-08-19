import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/custom_app_bar.dart';

/// Rate the delivery driver after order completion. Redesigned with premium star ratings,
/// avatar details, and clean button layouts.
class RateDriverView extends StatefulWidget {
  const RateDriverView({super.key});

  @override
  State<RateDriverView> createState() => _RateDriverViewState();
}

class _RateDriverViewState extends State<RateDriverView> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: const CustomAppBar(title: 'تقييم مندوب التوصيل'),
        body: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          child: Column(
            children: [
              AppCard(
                child: Column(
                  children: [
                    // Driver Avatar
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primaryLight, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 44.r,
                        backgroundColor: AppColors.white,
                        child: ClipOval(
                          child: AppAssetImage(
                            assetPath: Assets.images.avatarPlaceholder,
                            width: 88.w,
                            height: 88.w,
                            fit: BoxFit.cover,
                            fallbackIcon: Icons.person_rounded,
                          ),
                        ),
                      ),
                    ),
                    
                    Gap(14.h),
                    
                    Text(
                      'أحمد السعيد',
                      style: AppTextStyles.headingSmall.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Gap(4.h),
                    Text(
                      'كيف كانت سرعة التوصيل وأسلوب تعامل المندوب؟',
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
                      _rating == 0 ? 'اضغط لتقييم المندوب' : _driverRatingLabel(_rating),
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
                label: 'التالي — كتابة مراجعة نصية',
                icon: Icons.edit_note_rounded,
                onPressed: _rating > 0 ? () => context.push(AppRoutes.leaveReview) : null,
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

  String _driverRatingLabel(int r) => switch (r) {
        1 => 'سيء جداً 😞',
        2 => 'سيء 🙁',
        3 => 'مقبول 😐',
        4 => 'سريع ومحترم 🙂',
        _ => 'ممتاز ولبق جداً! 😍',
      };
}
