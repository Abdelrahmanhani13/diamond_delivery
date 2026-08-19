import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_radius.dart';
import '../../features/stores/domain/entities/vendor.dart';

class VendorCard extends StatelessWidget {
  const VendorCard({super.key, required this.vendor, this.onTap});

  final Vendor vendor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: AppColors.greyLight,
                    child: vendor.coverUrl.isNotEmpty
                        ? Image.network(vendor.coverUrl, fit: BoxFit.cover)
                        : const Icon(Icons.store, color: AppColors.textHint, size: 50),
                  ),
                ),
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: _Badge(
                    label: vendor.isOpen ? 'مفتوح' : 'مغلق',
                    color: vendor.isOpen ? AppColors.primary : AppColors.error,
                  ),
                ),
                Positioned(
                  top: 10.h,
                  left: 10.w,
                  child: CircleAvatar(
                    backgroundColor: AppColors.white,
                    child: Icon(
                      vendor.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star_rounded, size: 16.sp, color: AppColors.rating),
                      SizedBox(width: 3.w),
                      Text(
                        '${vendor.rating}',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(vendor.name, style: AppTextStyles.headingSmall),
                  SizedBox(height: 2.h),
                  Text(vendor.category, style: AppTextStyles.bodySmall),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14.sp, color: AppColors.textSecondary),
                      SizedBox(width: 4.w),
                      Text('${vendor.distanceKm.toStringAsFixed(1)} كم', style: AppTextStyles.bodySmall),
                      SizedBox(width: 10.w),
                      Container(
                        width: 3.w,
                        height: 3.w,
                        decoration: const BoxDecoration(color: AppColors.textHint, shape: BoxShape.circle),
                      ),
                      SizedBox(width: 10.w),
                      Text('توصيل: ${vendor.deliveryFee} ر.س', style: AppTextStyles.bodySmall),
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

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppRadius.xs)),
      child: Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.white)),
    );
  }
}
