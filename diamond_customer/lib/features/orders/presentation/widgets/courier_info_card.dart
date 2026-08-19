import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/app_card.dart';

/// A card showing the delivery courier's info: name, rating,
/// vehicle, and call/chat action buttons.
class CourierInfoCard extends StatelessWidget {
  const CourierInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryLight, width: 2),
            ),
            child: CircleAvatar(
              radius: 28.r,
              backgroundColor: AppColors.white,
              child: ClipOval(
                child: AppAssetImage(
                  assetPath: Assets.images.avatarPlaceholder,
                  width: 56.w,
                  height: 56.w,
                  fit: BoxFit.cover,
                  fallbackIcon: Icons.person_rounded,
                ),
              ),
            ),
          ),
          Gap(14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أحمد السعيد',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(2.h),
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 14.sp,
                      color: AppColors.rating,
                    ),
                    Gap(2.w),
                    Text('4.9 (ممتاز)', style: AppTextStyles.bodySmall),
                    Gap(8.w),
                    Container(
                      width: 4.w,
                      height: 4.w,
                      decoration: const BoxDecoration(
                        color: AppColors.textHint,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Gap(8.w),
                    Flexible(
                      child: Text(
                        'تويوتا كامري - د 1234',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primaryLight,
              foregroundColor: AppColors.primary,
            ),
            icon: Icon(Icons.phone_rounded, size: 20.sp),
          ),
          Gap(8.w),
          IconButton(
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primaryLight,
              foregroundColor: AppColors.primary,
            ),
            icon: Icon(Icons.chat_bubble_outline_rounded, size: 20.sp),
          ),
        ],
      ),
    );
  }
}
