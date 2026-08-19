import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_radius.dart';

/// Selectable summary row used in Checkout for Address / Payment method,
/// each opening its own selection screen via "تغيير".
class CheckoutSectionCard extends StatelessWidget {
  const CheckoutSectionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onChange,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(AppRadius.sm)),
            child: Icon(icon, color: AppColors.primary, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.bodySmall),
                SizedBox(height: 2.h),
                Text(value, style: AppTextStyles.bodyLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          TextButton(onPressed: onChange, child: Text('تغيير', style: AppTextStyles.link)),
        ],
      ),
    );
  }
}
