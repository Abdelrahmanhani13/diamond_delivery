import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/widgets/app_asset_image.dart';

class ProductImageSlider extends StatefulWidget {
  const ProductImageSlider({super.key, required this.imageUrls});

  final List<String> imageUrls;

  @override
  State<ProductImageSlider> createState() => _ProductImageSliderState();
}

class _ProductImageSliderState extends State<ProductImageSlider> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.imageUrls.isEmpty ? ['default'] : widget.imageUrls;

    return Stack(
      children: [
        SizedBox(
          height: 280.h,
          width: double.infinity,
          child: PageView.builder(
            controller: _controller,
            itemCount: images.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) {
              if (images[i] == 'default') {
                return Container(
                  color: AppColors.greyLight,
                  child: AppAssetImage(
                    assetPath: Assets.images.productImage,
                    fit: BoxFit.cover,
                    fallbackIcon: Icons.fastfood_rounded,
                  ),
                );
              }
              return Container(
                color: AppColors.greyLight,
                child: Image.network(images[i], fit: BoxFit.cover),
              );
            },
          ),
        ),
        Positioned(
          bottom: 14.h,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (i) {
              final active = i == _index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: active ? 20.w : 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : AppColors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
