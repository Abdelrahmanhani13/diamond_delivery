import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/assets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_asset_image.dart';
import '../../../../stores/domain/entities/vendor.dart';

/// The expandable SliverAppBar header showing vendor details
/// (cover image, name, rating, delivery fee, open/closed status).
class VendorDetailsAppBar extends StatelessWidget {
  const VendorDetailsAppBar({
    super.key,
    required this.vendor,
  });

  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 180.h,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: CircleAvatar(
        backgroundColor: AppColors.white.withValues(alpha: 0.9),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            vendor.coverUrl.isNotEmpty
                ? Image.network(vendor.coverUrl, fit: BoxFit.cover)
                : AppAssetImage(
                    assetPath: Assets.images.storeImage,
                    fit: BoxFit.cover,
                  ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16.h,
              right: 16.w,
              left: 16.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: vendor.isOpen ? AppColors.accent : AppColors.error,
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                    ),
                    child: Text(
                      vendor.isOpen ? 'مفتوح الآن' : 'مغلق',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Gap(6.h),
                  Text(
                    vendor.name,
                    style: AppTextStyles.headingLarge.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 14.sp,
                        color: AppColors.rating,
                      ),
                      Gap(2.w),
                      Text(
                        '${vendor.rating}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      Gap(12.w),
                      Icon(
                        Icons.delivery_dining,
                        size: 14.sp,
                        color: AppColors.white,
                      ),
                      Gap(4.w),
                      Text(
                        '${vendor.deliveryFee} ر.س',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
