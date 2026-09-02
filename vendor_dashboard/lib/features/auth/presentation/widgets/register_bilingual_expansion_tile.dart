import 'package:flutter/material.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';
import '../../../../core/utils/localized_entity_extension.dart';

class RegisterBilingualExpansionTile extends StatelessWidget {
  final TextEditingController nameEnController;
  final TextEditingController descriptionEnController;

  const RegisterBilingualExpansionTile({
    super.key,
    required this.nameEnController,
    required this.descriptionEnController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: VendorColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: VendorColors.border),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        iconColor: VendorColors.primary,
        collapsedIconColor: VendorColors.textSecondary,
        title: Text(
          context.tr('bilingualOptions'),
          style: VendorTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: VendorColors.primary,
          ),
        ),
        children: [
          TextFormField(
            controller: nameEnController,
            textDirection: TextDirection.ltr,
            decoration: InputDecoration(
              labelText: context.tr('storeNameEn'),
              prefixIcon: const Icon(Icons.storefront_outlined),
              hintText: 'e.g. Diamond Sweets',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: descriptionEnController,
            textDirection: TextDirection.ltr,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: context.tr('storeDescriptionEn'),
              prefixIcon: const Icon(Icons.description_outlined),
              hintText: 'e.g. Best sweets and cakes in town',
            ),
          ),
        ],
      ),
    );
  }
}
