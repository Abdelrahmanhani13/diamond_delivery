import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_radius.dart';

class NotificationData {
  const NotificationData({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    this.unread = false,
  });

  final String title;
  final String message;
  final String time;
  final IconData icon;
  final bool unread;
}

/// Notification row with unread indicator, matching the app's card style.
class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.data, this.onTap});

  final NotificationData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: data.unread ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
              child: Icon(data.icon, size: 20.sp, color: AppColors.primary),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(data.title, style: AppTextStyles.bodyLarge)),
                      Text(data.time, style: AppTextStyles.caption),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(data.message, style: AppTextStyles.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            if (data.unread) ...[
              SizedBox(width: 6.w),
              Container(width: 8.w, height: 8.w, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
            ],
          ],
        ),
      ),
    );
  }
}
