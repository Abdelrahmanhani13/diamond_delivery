import 'package:diamond_customer/features/products/presentation/widgets/product_image_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';

class ProductHeaderGallery extends StatelessWidget {
  const ProductHeaderGallery({
    super.key,
    required this.imageUrls,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  final List<String> imageUrls;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ProductImageSlider(imageUrls: imageUrls),
        Positioned(
          top: 16.h,
          right: 16.w,
          child: CircleAvatar(
            backgroundColor: AppColors.white.withValues(alpha: 0.9),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.textPrimary,
              ),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        Positioned(
          top: 16.h,
          left: 16.w,
          child: CircleAvatar(
            backgroundColor: AppColors.white.withValues(alpha: 0.9),
            child: IconButton(
              icon: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                size: 18,
                color: isFavorite ? AppColors.error : AppColors.textPrimary,
              ),
              onPressed: onFavoriteToggle,
            ),
          ),
        ),
      ],
    );
  }
}
