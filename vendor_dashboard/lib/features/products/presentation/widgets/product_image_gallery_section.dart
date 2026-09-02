import 'package:flutter/material.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';
import '../../domain/entities/vendor_product.dart';

class ProductImageGallerySection extends StatelessWidget {
  final List<VendorProductImage> images;
  final bool isUploading;
  final VoidCallback onAddImage;
  final ValueChanged<VendorProductImage> onSetPrimary;
  final ValueChanged<VendorProductImage> onDeleteImage;

  const ProductImageGallerySection({
    super.key,
    required this.images,
    required this.isUploading,
    required this.onAddImage,
    required this.onSetPrimary,
    required this.onDeleteImage,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('صور المنتج', style: VendorTextStyles.headingSmall),
              OutlinedButton.icon(
                onPressed: isUploading ? null : onAddImage,
                icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
                label: const Text('إضافة صورة'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isUploading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: CircularProgressIndicator(
                  color: VendorColors.primary,
                  strokeWidth: 2,
                ),
              ),
            )
          else if (images.isEmpty)
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: VendorColors.greyLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: VendorColors.border),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.image_outlined,
                      size: 40,
                      color: VendorColors.grey,
                    ),
                    const SizedBox(height: 8),
                    Text('لا توجد صور', style: VendorTextStyles.bodySmall),
                  ],
                ),
              ),
            )
          else
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final image = images[index];
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          image.url,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 120,
                            height: 120,
                            color: VendorColors.greyLight,
                            child: const Icon(Icons.broken_image_outlined),
                          ),
                        ),
                      ),
                      if (image.isPrimary)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: VendorColors.primary,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'رئيسية',
                              style: VendorTextStyles.caption.copyWith(
                                color: VendorColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 4,
                        left: 4,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!image.isPrimary)
                              _ImageActionButton(
                                icon: Icons.star_outline_rounded,
                                color: VendorColors.accent,
                                onTap: () => onSetPrimary(image),
                              ),
                            const SizedBox(width: 4),
                            _ImageActionButton(
                              icon: Icons.delete_outline_rounded,
                              color: VendorColors.error,
                              onTap: () => onDeleteImage(image),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _ImageActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ImageActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: VendorColors.surface.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
