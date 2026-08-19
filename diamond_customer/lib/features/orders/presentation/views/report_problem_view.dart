import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/custom_app_bar.dart';

/// Report a problem with an order (UI only). Redesigned with premium option cards.
class ReportProblemView extends StatefulWidget {
  const ReportProblemView({super.key});

  @override
  State<ReportProblemView> createState() => _ReportProblemViewState();
}

class _ReportProblemViewState extends State<ReportProblemView> {
  int _selected = 0;
  final _detailsController = TextEditingController();

  static const _issues = [
    ('طلب ناقص (أغراض مفقودة)', Icons.remove_shopping_cart_outlined),
    ('طلب خاطئ (تلقيت وجبات أخرى)', Icons.wrong_location_outlined),
    ('جودة طعام سيئة أو غير طازج', Icons.sentiment_very_dissatisfied_outlined),
    ('تأخر شديد في توصيل الطلب', Icons.more_time_outlined),
    ('مشكلة في الدفع أو سحب المبلغ', Icons.money_off_rounded),
    ('مشكلة أخرى واجهتني', Icons.help_outline_rounded),
  ];

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: const CustomAppBar(title: 'الإبلاغ عن مشكلة بالطلب'),
        body: ListView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          children: [
            Text(
              'ما هي المشكلة التي واجهتك؟',
              style: AppTextStyles.headingSmall.copyWith(fontWeight: FontWeight.bold),
            ).animate().fadeIn(duration: 250.ms),
            Gap(12.h),
            
            // Premium custom option tiles
            ...List.generate(_issues.length, (i) {
              final isSelected = _selected == i;
              final (label, icon) = _issues[i];
              
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow.withValues(alpha: 0.01),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => setState(() => _selected = i),
                      borderRadius: BorderRadius.circular(16.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        child: Row(
                          children: [
                            Icon(
                              icon,
                              color: isSelected ? AppColors.primary : AppColors.textSecondary,
                              size: 20.sp,
                            ),
                            Gap(12.w),
                            Expanded(
                              child: Text(
                                label,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                            Icon(
                              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                              color: isSelected ? AppColors.primary : AppColors.textHint,
                              size: 20.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: (i * 40).ms, duration: 250.ms).slideY(begin: 0.05, end: 0);
            }),
            
            Gap(20.h),
            
            // Description input
            AppCard(
              child: AppTextField(
                controller: _detailsController,
                label: 'تفاصيل المشكلة (اختياري)',
                hint: 'يرجى تقديم تفاصيل لمساعدتنا على حل المشكلة بأسرع وقت...',
              ),
            ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
            
            Gap(28.h),
            
            // Action buttons
            AppButton(
              label: 'إرسال الشكوى والبلاغ',
              icon: Icons.report_problem_outlined,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.primary,
                    content: Text(
                      'تم إرسال بلاغك بنجاح. سيقوم فريق الدعم بمراجعته والتواصل معك.',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
                context.pop();
              },
            ),
            
            Gap(10.h),
            
            AppButton(
              label: 'التحدث مع الدعم المباشر',
              variant: AppButtonVariant.outline,
              icon: Icons.headset_mic_outlined,
              onPressed: () => context.push(AppRoutes.contactSupport),
            ),
          ],
        ),
      ),
    );
  }
}
