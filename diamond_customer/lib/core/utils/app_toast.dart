import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import '../theme/app_colors.dart';

/// Centralized, beautiful toast notifications for the entire app.
/// Uses the `toastification` package with overlay — zero performance impact.
///
/// Usage:
///   AppToast.success(context, message: 'تم الحفظ بنجاح');
///   AppToast.error(context, message: 'حدث خطأ ما');
///   AppToast.warning(context, message: 'تنبيه: تحقق من البيانات');
///   AppToast.info(context, message: 'جاري التحميل...');
class AppToast {
  AppToast._();

  static void success(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      type: ToastificationType.success,
      title: title ?? 'تم بنجاح',
      description: message,
      primaryColor: AppColors.success,
      icon: Icons.check_circle_rounded,
      duration: duration,
    );
  }

  static void error(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    _show(
      context,
      type: ToastificationType.error,
      title: title ?? 'خطأ',
      description: message,
      primaryColor: AppColors.error,
      icon: Icons.error_rounded,
      duration: duration,
    );
  }

  static void warning(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    _show(
      context,
      type: ToastificationType.warning,
      title: title ?? 'تنبيه',
      description: message,
      primaryColor: AppColors.warning,
      icon: Icons.warning_rounded,
      duration: duration,
    );
  }

  static void info(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      type: ToastificationType.info,
      title: title ?? 'معلومة',
      description: message,
      primaryColor: AppColors.info,
      icon: Icons.info_rounded,
      duration: duration,
    );
  }

  static void _show(
    BuildContext context, {
    required ToastificationType type,
    required String title,
    required String description,
    required Color primaryColor,
    required IconData icon,
    required Duration duration,
  }) {
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flatColored,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
      description: Text(
        description,
        style: const TextStyle(
          fontSize: 13,
          height: 1.4,
        ),
      ),
      alignment: Alignment.topCenter,
      autoCloseDuration: duration,
      primaryColor: primaryColor,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: primaryColor.withValues(alpha: 0.15),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
      showProgressBar: true,
      dragToClose: true,
      pauseOnHover: true,
      applyBlurEffect: true,
      direction: TextDirection.rtl,
    );
  }
}
