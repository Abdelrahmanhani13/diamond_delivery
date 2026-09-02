import 'package:flutter/material.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';
import '../../../../core/utils/localized_entity_extension.dart';

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
          Text(
            context.tr('businessInfoSection'),
            style: VendorTextStyles.headingSmall,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: subCategoryIdController,
            decoration: const InputDecoration(
              labelText: 'SubCategory ID (GUID)',
              prefixIcon: Icon(Icons.category_outlined),
            ),
            validator: (v) => v == null || v.trim().isEmpty
                ? context.tr('fieldRequired')
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: nameArabicController,
            decoration: InputDecoration(
              labelText: '${context.tr('productName')} (العربية)',
              prefixIcon: const Icon(Icons.diamond_outlined),
            ),
            validator: (v) => v == null || v.trim().isEmpty
                ? context.tr('fieldRequired')
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: nameEnglishController,
            textDirection: TextDirection.ltr,
            decoration: InputDecoration(
              labelText: '${context.tr('productName')} (English)',
              prefixIcon: const Icon(Icons.diamond_outlined),
            ),
            validator: (v) => v == null || v.trim().isEmpty
                ? context.tr('fieldRequired')
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: descriptionArabicController,
            decoration: InputDecoration(
              labelText: '${context.tr('storeDescription')} (العربية)',
              prefixIcon: const Icon(Icons.description_outlined),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: descriptionEnglishController,
            textDirection: TextDirection.ltr,
            decoration: InputDecoration(
              labelText: '${context.tr('storeDescription')} (English)',
              prefixIcon: const Icon(Icons.description_outlined),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: priceController,
            decoration: InputDecoration(
              labelText: context.tr('productPrice'),
              prefixIcon: const Icon(Icons.attach_money_rounded),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return context.tr('fieldRequired');
              }
              if (double.tryParse(v.trim()) == null) {
                return context.tr('invalidNumber');
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
