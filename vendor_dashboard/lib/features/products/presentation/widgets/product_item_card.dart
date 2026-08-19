import 'package:flutter/material.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';
import '../../domain/entities/vendor_product.dart';

class ProductItemCard extends StatelessWidget {
  final VendorProduct product;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final ValueChanged<bool> onAvailabilityChanged;

  const ProductItemCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onDelete,
    required this.onAvailabilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primaryImage = product.images.isNotEmpty
        ? product.images.firstWhere(
            (img) => img.isPrimary,
            orElse: () => product.images.first,
          )
        : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              child: Container(
                width: 100,
                height: 100,
                color: VendorColors.greyLight,
                child: primaryImage != null
                    ? Image.network(
                        primaryImage.url,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.diamond_outlined,
                          size: 40,
                          color: VendorColors.grey,
                        ),
                      )
                    : const Icon(
                        Icons.diamond_outlined,
                        size: 40,
                        color: VendorColors.grey,
                      ),
              ),
            ),
            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: VendorTextStyles.headingSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      style: VendorTextStyles.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${product.price.toStringAsFixed(2)} ر.س',
                          style: VendorTextStyles.price,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: product.isAvailable
                                ? VendorColors.success.withValues(alpha: 0.1)
                                : VendorColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            product.isAvailable ? 'متوفر' : 'غير متوفر',
                            style: VendorTextStyles.caption.copyWith(
                              color: product.isAvailable
                                  ? VendorColors.success
                                  : VendorColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Actions column
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: product.isAvailable,
                    onChanged: onAvailabilityChanged,
                    activeThumbColor: VendorColors.primary,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: VendorColors.error,
                      size: 20,
                    ),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
