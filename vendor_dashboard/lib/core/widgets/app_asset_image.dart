import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_radius.dart';
import '../theme/app_colors.dart';

/// Renders an asset from [Assets] with graceful SVG/PNG support and icon fallback.
class AppAssetImage extends StatelessWidget {
  const AppAssetImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.fallbackIcon = Icons.image_outlined,
    this.fallbackColor = AppColors.primary,
    this.borderRadius,
  });

  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final IconData fallbackIcon;
  final Color fallbackColor;
  final BorderRadius? borderRadius;

  bool get _isSvg => assetPath.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    final child = _isSvg
        ? SvgPicture.asset(
            assetPath,
            width: width,
            height: height,
            fit: fit,
            placeholderBuilder: (_) => _fallback(),
          )
        : Image.asset(
            assetPath,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, _, _) => _fallback(),
          );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }

  Widget _fallback() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.md),
      ),
      alignment: Alignment.center,
      child: Icon(
        fallbackIcon,
        color: fallbackColor,
        size: (height ?? 48) * 0.45,
      ),
    );
  }
}
