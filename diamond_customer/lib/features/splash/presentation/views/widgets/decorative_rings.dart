import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

/// Abstract decorative thin rings animating in the background of splash screen.
class DecorativeRings extends StatelessWidget {
  const DecorativeRings({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: 0.15,
          child: Container(
            width: 260.w,
            height: 260.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 1),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 1000.ms)
            .scale(
              begin: const Offset(0.7, 0.7),
              end: const Offset(1.0, 1.0),
              duration: 1500.ms,
              curve: Curves.easeOutCubic,
            ),
        Opacity(
          opacity: 0.08,
          child: Container(
            width: 340.w,
            height: 340.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 1.5),
            ),
          ),
        )
            .animate()
            .fadeIn(delay: 200.ms, duration: 1200.ms)
            .scale(
              begin: const Offset(0.7, 0.7),
              end: const Offset(1.0, 1.0),
              duration: 1800.ms,
              curve: Curves.easeOutCubic,
            ),
      ],
    );
  }
}
