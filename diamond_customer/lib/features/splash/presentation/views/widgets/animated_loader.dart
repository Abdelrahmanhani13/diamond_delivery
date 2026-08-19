import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// A custom elegant loading dots indicator and text shown during splash initialization.
class AnimatedLoader extends StatelessWidget {
  const AnimatedLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Container(
              width: 8.w,
              height: 8.w,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
            )
                .animate(onPlay: (c) => c.repeat())
                .scale(
                  begin: const Offset(0.6, 0.6),
                  end: const Offset(1.4, 1.4),
                  duration: 600.ms,
                  delay: (index * 200).ms,
                  curve: Curves.easeInOut,
                )
                .then()
                .scale(
                  begin: const Offset(1.4, 1.4),
                  end: const Offset(0.6, 0.6),
                  duration: 600.ms,
                  curve: Curves.easeInOut,
                );
          }),
        ),
        SizedBox(height: 16.h),
        Text(
          'جاري تهيئة التطبيق...',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.white.withValues(alpha: 0.6),
            letterSpacing: 0.2,
          ),
        ).animate().fadeIn(delay: 1000.ms, duration: 500.ms),
      ],
    );
  }
}
