import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/custom_app_bar.dart';

/// Contact support screen with FAQs accordion and call/chat shortcuts.
/// Redesigned to represent a premium support experience.
class ContactSupportView extends StatefulWidget {
  const ContactSupportView({super.key});

  @override
  State<ContactSupportView> createState() => _ContactSupportViewState();
}

class _ContactSupportViewState extends State<ContactSupportView> {
  final _messageController = TextEditingController();
  final Map<int, bool> _expandedFaq = {};

  static const _faqs = [
    ('كيف يمكنني تتبع طلبي؟', 'يمكنك تتبع طلبك مباشرة بالضغط على زر "تتبع الطلب" في تفاصيل الطلب أو شاشة تأكيد الطلب الناجحة.'),
    ('كيف يمكنني إلغاء الطلب بعد الدفع؟', 'تواصل مع الدعم الفني مباشرة من خلال المحادثة الفورية خلال ٥ دقائق من الطلب لإلغائه قبل تحضيره.'),
    ('ما هي سياسة الاسترجاع والتعويض؟', 'إذا كان هناك أي نقص أو خطأ في الوجبات، يرجى الإبلاغ عن مشكلة وسيقوم فريق الدعم بالتعويض المالي للمحفظة.'),
    ('كيف أقوم بتغيير عنوان التوصيل المختار؟', 'يمكنك تغيير العنوان أو إضافته من صفحة "الملف الشخصي" -> "عناويني" أو أثناء خطوة الدفع بسهولة.'),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: const CustomAppBar(title: 'مركز الدعم والمساعدة'),
        body: ListView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          children: [
            // Active Support Team card
            AppCard(
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Icon(Icons.headset_mic_rounded, color: AppColors.primary, size: 24.sp),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('فريق مساعدة ديموند', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                        Text('نشطون ومستعدون للمساعدة ٢٤/٧', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.05, end: 0),
            
            Gap(16.h),
            
            // Call & Chat shortcuts
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'اتصال هاتفي مباشر',
                    icon: Icons.phone_rounded,
                    onPressed: () {},
                  ),
                ),
                Gap(10.w),
                Expanded(
                  child: AppButton(
                    label: 'محادثة فورية',
                    variant: AppButtonVariant.outline,
                    icon: Icons.chat_bubble_outline_rounded,
                    onPressed: () {},
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 100.ms, duration: 300.ms),
            
            Gap(24.h),
            
            // FAQ lists
            Text('الأسئلة الشائعة والمتكررة', style: AppTextStyles.headingSmall.copyWith(fontWeight: FontWeight.bold)),
            Gap(10.h),
            ...List.generate(_faqs.length, (index) {
              final (question, answer) = _faqs[index];
              final isExpanded = _expandedFaq[index] ?? false;
              
              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withValues(alpha: 0.01),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(question, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                      trailing: Icon(
                        isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                        color: AppColors.textSecondary,
                      ),
                      onTap: () => setState(() => _expandedFaq[index] = !isExpanded),
                    ),
                    if (isExpanded)
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            answer,
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.5),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }).animate(interval: 50.ms).fadeIn(delay: 150.ms),
            
            Gap(20.h),
            
            // Text field message box
            AppCard(
              child: AppTextField(
                controller: _messageController,
                label: 'راسلنا مباشرة',
                hint: 'اكتب استفسارك أو مشكلتك بالتفصيل وسنتواصل معك فوراً...',
              ),
            ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
            
            Gap(16.h),
            
            AppButton(
              label: 'إرسال الرسالة إلى الدعم',
              icon: Icons.send_rounded,
              onPressed: () {
                if (_messageController.text.trim().isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.primary,
                      content: Text(
                        'تم إرسال استفسارك بنجاح. سنرد عليك في أقرب وقت.',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                  _messageController.clear();
                }
              },
            ).animate().fadeIn(delay: 300.ms),
          ],
        ),
      ),
    );
  }
}
