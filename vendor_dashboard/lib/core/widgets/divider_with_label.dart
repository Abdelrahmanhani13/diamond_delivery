import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Horizontal divider with centered label — used for "or continue with" sections.
class DividerWithLabel extends StatelessWidget {
  const DividerWithLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.divider)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(label, style: AppTextStyles.bodySmall),
        ),
        const Expanded(child: Divider(color: AppColors.divider)),
      ],
    );
  }
}
