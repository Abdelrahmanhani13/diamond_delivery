import 'package:flutter/material.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';
import '../../../../core/utils/localized_entity_extension.dart';

class ProductPricingInventorySection extends StatelessWidget {
  final TextEditingController discountPriceController;
  final TextEditingController stockQuantityController;
  final TextEditingController skuController;
  final TextEditingController barcodeController;
  final TextEditingController weightController;

  const ProductPricingInventorySection({
    super.key,
    required this.discountPriceController,
    required this.stockQuantityController,
    required this.skuController,
    required this.barcodeController,
    required this.weightController,
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
            context.tr('financialsSection'),
            style: VendorTextStyles.headingSmall,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: discountPriceController,
            decoration: InputDecoration(
              labelText: context.tr('discountPrice'),
              prefixIcon: const Icon(Icons.discount_outlined),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: stockQuantityController,
            decoration: InputDecoration(
              labelText: context.tr('stockQuantity'),
              prefixIcon: const Icon(Icons.inventory_2_outlined),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: skuController,
            decoration: InputDecoration(
              labelText: context.tr('sku'),
              prefixIcon: const Icon(Icons.qr_code_outlined),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: barcodeController,
            decoration: InputDecoration(
              labelText: context.tr('barcode'),
              prefixIcon: const Icon(Icons.barcode_reader),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: weightController,
            decoration: InputDecoration(
              labelText: context.tr('weight'),
              prefixIcon: const Icon(Icons.scale_outlined),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
    );
  }
}
