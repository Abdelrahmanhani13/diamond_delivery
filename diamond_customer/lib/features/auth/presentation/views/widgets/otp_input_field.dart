import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// A styled OTP input field built on top of Pinput with centralized themes.
class OtpInputField extends StatelessWidget {
  const OtpInputField({
    super.key,
    required this.length,
    required this.controller,
    required this.focusNode,
    this.errorText,
    required this.onCompleted,
    required this.onChanged,
  });

  final int length;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? errorText;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    // ثيمات الـ Pinput. مبنية فوق بعض: default -> focused -> submitted -> error
    // بيرثوا من بعض عشان أي تعديل مركزي (زي الحجم) يتغير في مكان واحد.
    final defaultPinTheme = PinTheme(
      width: 60.w,
      height: 60.w,
      textStyle: AppTextStyles.headingLarge,
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primary, width: 1.5),
      borderRadius: BorderRadius.circular(AppRadius.md),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: AppColors.primary.withValues(alpha: 0.08),
        border: Border.all(color: AppColors.primary, width: 1.2),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.red, width: 1.5),
    );

    // أرقام الـ OTP بتفضل LTR حتى جوه شاشة RTL،
    // ده الشكل المتعارف عليه في كل تطبيقات الـ OTP.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        length: length,
        controller: controller,
        focusNode: focusNode,
        autofocus: true,
        closeKeyboardWhenCompleted: true,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        errorPinTheme: errorPinTheme,
        forceErrorState: errorText != null,
        errorText: errorText,
        errorTextStyle: AppTextStyles.bodySmall.copyWith(
          color: Colors.red,
        ),
        pinAnimationType: PinAnimationType.fade,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        // بيحاول ياخد الكود تلقائياً من رسالة الـ SMS
        // على أندرويد وiOS من غير ما المستخدم يكتبه يدوي.
        onCompleted: onCompleted,
        onChanged: onChanged,
      ),
    );
  }
}
