import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// A text section at the bottom of the register form showing the
/// terms of service and privacy policy agreement text.
class RegisterTermsText extends StatelessWidget {
  const RegisterTermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text.rich(
        TextSpan(
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          children: [
            const TextSpan(
              text: 'بإنشائك حساباً فإنك توافق تلقائياً على ',
            ),
            TextSpan(
              text: 'شروط الاستخدام',
              style: AppTextStyles.link.copyWith(
                fontSize: AppTextStyles.bodySmall.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(text: ' و '),
            TextSpan(
              text: 'سياسة الخصوصية',
              style: AppTextStyles.link.copyWith(
                fontSize: AppTextStyles.bodySmall.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(text: ' المعمول بها لدينا.'),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
