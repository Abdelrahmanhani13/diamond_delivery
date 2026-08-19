import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/custom_app_bar.dart';

/// Tax invoice preview and download screen. Redesigned to simulate an elegant receipt view.
class DownloadInvoiceView extends StatelessWidget {
  const DownloadInvoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: const CustomAppBar(title: 'الفاتورة الضريبية المبسطة'),
        body: ListView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          children: [
            // Styled Receipt Card
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Diamond Village',
                      style: AppTextStyles.headingLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Gap(4.h),
                  Center(
                    child: Text(
                      'الرقم الضريبي: ٣٠١٢٣٤٥٦٧٨٠٠٠٠٣',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Gap(6.h),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      child: Text(
                        'فاتورة ضريبية مبسطة',
                        style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  
                  Gap(24.h),
                  
                  // Metadata
                  _row('رقم الفاتورة الموحد', 'INV-10234'),
                  _row('تاريخ ووقت الشراء', '22 يوليو 2026 ، 14:42'),
                  _row('اسم المتجر المصدر', 'برجر هاوس'),
                  
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    child: const _DottedDivider(),
                  ),
                  
                  // Items table heading
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('الصنف والكمية', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                      Text('القيمة المالية', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                    ],
                  ),
                  Gap(10.h),
                  
                  _row('برجر لحم مزدوج سوبريم × 2', '60.00 ر.س'),
                  _row('بطاطس مقلية بالجبنة × 1', '12.00 ر.س'),
                  _row('رسوم وتكاليف التوصيل', '10.00 ر.س'),
                  
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    child: const _DottedDivider(),
                  ),
                  
                  _row('المجموع الفرعي (غير شامل ضريبة القيمة المضافة)', '62.61 ر.س'),
                  _row('ضريبة القيمة المضافة (١٥%)', '9.39 ر.س'),
                  
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    child: const _DottedDivider(),
                  ),
                  
                  _row('الإجمالي النهائي (شامل ضريبة القيمة المضافة)', '82.00 ر.س', bold: true),
                  _row('قنوات وطريقة الدفع المتبعة', 'نقداً عند الاستلام'),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),
            
            Gap(24.h),
            
            // Actions
            AppButton(
              label: 'تحميل كملف PDF ضريبي',
              icon: Icons.picture_as_pdf_outlined,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.primary,
                    content: Text(
                      'جاري تحميل الفاتورة الضريبية بصيغة PDF...',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
            
            Gap(10.h),
            
            AppButton(
              label: 'مشاركة الفاتورة',
              variant: AppButtonVariant.outline,
              icon: Icons.share_outlined,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    final style = bold ? AppTextStyles.bodyLarge : AppTextStyles.bodyMedium;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style.copyWith(color: bold ? AppColors.textPrimary : AppColors.textPrimary.withValues(alpha: 0.9))),
          Text(value, style: style.copyWith(fontWeight: bold ? FontWeight.w900 : FontWeight.bold, color: bold ? AppColors.primary : AppColors.textPrimary)),
        ],
      ),
    );
  }
}

/// Dotted divider line for receipt layout.
class _DottedDivider extends StatelessWidget {
  const _DottedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        final dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: AppColors.border),
              ),
            );
          }),
        );
      },
    );
  }
}
