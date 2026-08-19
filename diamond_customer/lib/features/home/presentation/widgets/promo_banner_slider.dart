import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/widgets/app_button.dart';

/// Auto-height promotional banner slider, e.g. "خصم 30% على أول طلب".
/// TODO: replace gradient background with Assets.images.promoBanner once
/// real creative assets are provided.
class PromoBannerSlider extends StatefulWidget {
  const PromoBannerSlider({super.key, required this.banners, this.onCtaTap});

  final List<PromoBannerData> banners;
  final ValueChanged<int>? onCtaTap;

  @override
  State<PromoBannerSlider> createState() => _PromoBannerSliderState();
}

class _PromoBannerSliderState extends State<PromoBannerSlider> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150.h,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.banners.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) {
              final banner = widget.banners[i];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(banner.tag, style: AppTextStyles.caption.copyWith(color: AppColors.white)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            banner.title,
                            textAlign: TextAlign.right,
                            style: AppTextStyles.headingMedium.copyWith(color: AppColors.white),
                          ),
                          SizedBox(height: 12.h),
                          AppButton(
                            label: banner.ctaLabel,
                            fullWidth: false,
                            height: 34.h,
                            variant: AppButtonVariant.secondary,
                            onPressed: () => widget.onCtaTap?.call(i),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.banners.length, (i) {
            final bool active = i == _index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              width: active ? 18.w : 6.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: active ? AppColors.primary : AppColors.border,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class PromoBannerData {
  const PromoBannerData({
    required this.tag,
    required this.title,
    required this.ctaLabel,
  });

  final String tag;
  final String title;
  final String ctaLabel;
}
