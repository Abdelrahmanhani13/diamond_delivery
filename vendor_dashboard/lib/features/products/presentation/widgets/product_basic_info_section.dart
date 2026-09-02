import 'package:flutter/material.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';

class ProductBasicInfoSection extends StatelessWidget {
  final TextEditingController subCategoryIdController;
  final TextEditingController nameArabicController;
  final TextEditingController nameEnglishController;
  final TextEditingController descriptionArabicController;
  final TextEditingController descriptionEnglishController;
  final TextEditingController priceController;

  const ProductBasicInfoSection({
    super.key,
    required this.subCategoryIdController,
    required this.nameArabicController,
    required this.nameEnglishController,
    required this.descriptionArabicController,
    required this.descriptionEnglishController,
    required this.priceController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: VendorColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: VendorColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('معلومات المنتج الأساسية', style: VendorTextStyles.headingSmall),
          const SizedBox(height: 16),
          TextFormField(
            controller: subCategoryIdController,
            decoration: const InputDecoration(
              labelText: 'رقم القسم الفرعي (subCategoryId)',
              prefixIcon: Icon(Icons.category_outlined),
              helperText: 'مؤقتًا: الصق الـ GUID لحد ما نعمل قايمة اختيار',
            ),
            validator: (v) => v == null || v.trim().isEmpty
                ? 'يرجى إدخال رقم القسم الفرعي'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: nameArabicController,
            decoration: const InputDecoration(
              labelText: 'اسم المنتج (عربي)',
              prefixIcon: Icon(Icons.diamond_outlined),
            ),
            validator: (v) => v == null || v.trim().isEmpty
                ? 'يرجى إدخال اسم المنتج بالعربي'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: nameEnglishController,
            decoration: const InputDecoration(
              labelText: 'اسم المنتج (إنجليزي)',
              prefixIcon: Icon(Icons.diamond_outlined),
            ),
            validator: (v) => v == null || v.trim().isEmpty
                ? 'يرجى إدخال اسم المنتج بالإنجليزي'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: descriptionArabicController,
            decoration: const InputDecoration(
              labelText: 'وصف المنتج (عربي)',
              prefixIcon: Icon(Icons.description_outlined),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: descriptionEnglishController,
            decoration: const InputDecoration(
              labelText: 'وصف المنتج (إنجليزي)',
              prefixIcon: Icon(Icons.description_outlined),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: priceController,
            decoration: const InputDecoration(
              labelText: 'السعر',
              prefixIcon: Icon(Icons.attach_money_rounded),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'يرجى إدخال السعر';
              }
              if (double.tryParse(v.trim()) == null) {
                return 'يرجى إدخال رقم صحيح';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
