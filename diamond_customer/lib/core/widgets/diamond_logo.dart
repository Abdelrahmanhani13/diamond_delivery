import 'package:diamond_customer/core/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import 'app_asset_image.dart';

/// Animated Diamond Village logo mark for splash and auth headers.
class DiamondLogo extends StatelessWidget {
  const DiamondLogo({
    super.key,
    this.size = 96,
    this.showGlow = false,
    this.animate = false,
  });

  final double size;
  final bool showGlow;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    Widget logo = Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: AppColors.white.withValues(alpha: 0.3),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ]
            : null,
      ),
      child: ClipOval(
        child: Padding(
          padding: EdgeInsets.all(size.w * 0.12),
          child: AppAssetImage(
            assetPath: Assets.images.logo,
            width: size.w * 0.76,
            height: size.w * 0.76,
            fallbackIcon: Icons.diamond_outlined,
          ),
        ),
      ),
    );

    if (animate) {
      logo = logo
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(
            begin: const Offset(0.95, 0.95),
            end: const Offset(1.05, 1.05),
            duration: 1200.ms,
            curve: Curves.easeInOut,
          );
    }

    return logo;
  }
}
