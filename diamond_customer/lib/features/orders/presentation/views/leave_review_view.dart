import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/custom_app_bar.dart';

/// Leave a written review after rating order and driver.
/// Redesigned with quick suggestion chips and curved text fields.
class LeaveReviewView extends StatefulWidget {
  const LeaveReviewView({super.key});

  @override
  State<LeaveReviewView> createState() => _LeaveReviewViewState();
}

class _LeaveReviewViewState extends State<LeaveReviewView> {
  final _controller = TextEditingController();
  final Set<String> _selectedSuggestions = {};

  static const _suggestions = [
    'توصيل سريع وممتاز ⚡',
    'طعام حار ولذيذ جداً 🔥',
    'تغليف نظيف ومحكم 📦',
    'مندوب خلوق ومهذب 🤝',
    'مطابق تماماً للطلب 👍',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSuggestion(String tag) {
    setState(() {
      if (_selectedSuggestions.contains(tag)) {
        _selectedSuggestions.remove(tag);
        // Remove from controller text
        _controller.text = _controller.text.replaceFirst(tag, '').trim();
      } else {
        _selectedSuggestions.add(tag);
        // Append to controller text
        if (_controller.text.isEmpty) {
          _controller.text = tag;
        } else {
          _controller.text = '${_controller.text} ، $tag';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: const CustomAppBar(title: 'كتابة مراجعة وتعليق'),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header title
              Text(
                'شاركنا تفاصيل تجربتك',
                style: AppTextStyles.headingMedium.copyWith(fontWeight: FontWeight.bold),
              ).animate().fadeIn(duration: 250.ms),
              Gap(4.h),
              Text(
                'مراجعتك المكتوبة تساعد الآخرين وتساهم في تحسين مستوى الخدمة.',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ).animate().fadeIn(delay: 100.ms, duration: 250.ms),
              
              Gap(20.h),

              // Suggestion Chips list
              Text(
                'عبارات سريعة مقترحة:',
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ).animate().fadeIn(delay: 150.ms),
              Gap(10.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: _suggestions.map((suggestion) {
                  final isSelected = _selectedSuggestions.contains(suggestion);
                  return FilterChip(
                    label: Text(suggestion),
                    selected: isSelected,
                    onSelected: (_) => _toggleSuggestion(suggestion),
                    selectedColor: AppColors.primaryLight,
                    checkmarkColor: AppColors.primary,
                    labelStyle: AppTextStyles.bodySmall.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.border,
                        width: 1,
                      ),
                    ),
                  );
                }).toList(),
              ).animate().fadeIn(delay: 200.ms),

              Gap(24.h),

              // Form card containing the text field
              AppCard(
                child: AppTextField(
                  controller: _controller,
                  hint: 'اكتب مراجعتك وتقييمك الصادق هنا...',
                  label: 'المراجعة والتعليق',
                ),
              ).animate().fadeIn(delay: 250.ms, duration: 400.ms).slideY(begin: 0.05, end: 0),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: AppButton(
              label: 'إرسال المراجعة والتعليق',
              icon: Icons.send_rounded,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.primary,
                    content: Text(
                      'شكراً جزيلاً لتقييمك الصادق ومراجعتك!',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
                context.pop();
              },
            ),
          ).animate().fadeIn(delay: 350.ms),
        ),
      ),
    );
  }
}
