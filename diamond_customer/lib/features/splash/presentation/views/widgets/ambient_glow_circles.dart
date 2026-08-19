import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

/// Animated background ambient glow circles for the splash screen.
class AmbientGlowCircles extends StatelessWidget {
  const AmbientGlowCircles({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Ambient Glow Circle Top-Left
        Positioned(
          top: -100.h,
          left: -100.w,
          child: Container(
            width: 350.w,
            height: 350.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent.withValues(alpha: 0.06),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(0.85, 0.85),
                end: const Offset(1.15, 1.15),
                duration: 3000.ms,
                curve: Curves.easeInOut,
              )
              .blurXY(begin: 40, end: 40, duration: 1.ms),
        ),

        // Ambient Glow Circle Bottom-Right
        Positioned(
          bottom: -80.h,
          right: -80.w,
          child: Container(
            width: 320.w,
            height: 320.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: 0.04),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(1.1, 1.1),
                end: const Offset(0.9, 0.9),
                duration: 2500.ms,
                curve: Curves.easeInOut,
              )
              .blurXY(begin: 50, end: 50, duration: 1.ms),
        ),
      ],
    );
  }
}
