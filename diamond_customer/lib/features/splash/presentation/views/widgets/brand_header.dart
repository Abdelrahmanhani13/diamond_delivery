import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/diamond_logo.dart';

/// The central logo and brand title for the splash screen, with entrance animations.
class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated glowing logo
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.2),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const DiamondLogo(
            size: 100,
            showGlow: false,
            animate: false,
          ),
        )
            .animate()
            .fadeIn(duration: 800.ms)
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1.0, 1.0),
              duration: 1000.ms,
              curve: Curves.elasticOut,
            ),

        SizedBox(height: 24.h),

        // Brand name with premium font weight
        Text(
          'Diamond Village',
          style: AppTextStyles.displayLarge.copyWith(
            color: AppColors.white,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w900,
          ),
        )
            .animate()
            .fadeIn(delay: 400.ms, duration: 600.ms)
            .slideY(
              begin: 0.4,
              end: 0,
              duration: 800.ms,
              curve: Curves.easeOutQuad,
            ),

        SizedBox(height: 8.h),

        // Tagline with elegant letter/word animation
        Text(
          'توصيل سريع • تسوق بثقة • خدمات متنوعة',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.white.withValues(alpha: 0.75),
            fontWeight: FontWeight.w500,
          ),
        )
            .animate()
            .fadeIn(delay: 800.ms, duration: 800.ms)
            .slideY(
              begin: 0.3,
              end: 0,
              duration: 800.ms,
              curve: Curves.easeOutQuad,
            ),
      ],
    );
  }
}
