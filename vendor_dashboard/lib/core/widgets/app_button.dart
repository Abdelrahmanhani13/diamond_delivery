import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_radius.dart';

enum AppButtonVariant { primary, secondary, outline, danger, text }

/// Single reusable button with proper loading / disabled / pressed states.
/// Use everywhere instead of raw ElevatedButton/TextButton.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.height,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final double? height;
  final bool fullWidth;

  bool get _disabled => onPressed == null || isLoading;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = switch (variant) {
      AppButtonVariant.primary => AppColors.primary,
      AppButtonVariant.secondary => AppColors.accent,
      AppButtonVariant.danger => AppColors.error,
      AppButtonVariant.outline => Colors.transparent,
      AppButtonVariant.text => Colors.transparent,
    };

    final Color fgColor = switch (variant) {
      AppButtonVariant.outline => AppColors.primary,
      AppButtonVariant.text => AppColors.primary,
      _ => AppColors.textOnPrimary,
    };

    final Color disabledBg = AppColors.disabled;

    Widget child = isLoading
        ? SizedBox(
            width: 20.w,
            height: 20.w,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation(fgColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18.sp, color: fgColor),
                SizedBox(width: 8.w),
              ],
              // FIX: Text كان بياخد عرضه الطبيعي الكامل من غير حد أقصى،
              // فلما الزرار يتحط جوه Expanded (زي زرارين جنب بعض)
              // وطول النص أكبر من المساحة المتاحة كان بيعمل RenderFlex
              // overflow. Flexible + ellipsis بيحل المشكلة في أي زرار
              // في التطبيق مش بس هنا.
              Flexible(
                child: Text(
                  label,
                  style: AppTextStyles.buttonLarge.copyWith(color: fgColor),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );

    final button = Material(
      color:
          _disabled &&
              variant != AppButtonVariant.outline &&
              variant != AppButtonVariant.text
          ? disabledBg
          : bgColor,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: _disabled ? null : onPressed,
        child: Container(
          height: height ?? 52.h,
          width: fullWidth ? double.infinity : null,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          alignment: Alignment.center,
          decoration: variant == AppButtonVariant.outline
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: _disabled ? AppColors.disabled : AppColors.primary,
                    width: 1.4,
                  ),
                )
              : null,
          child: child,
        ),
      ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
