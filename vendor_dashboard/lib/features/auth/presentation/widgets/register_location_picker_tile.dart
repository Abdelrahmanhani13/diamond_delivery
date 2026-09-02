import 'package:flutter/material.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';

class RegisterLocationPickerTile extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final String addressText;
  final VoidCallback onTap;

  const RegisterLocationPickerTile({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.addressText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'موقع المتجر',
          style: VendorTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: VendorColors.primaryLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: VendorColors.primary.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: VendorColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    latitude == null
                        ? 'اضغط لتحديد موقع المتجر على الخريطة'
                        : (addressText.isNotEmpty
                              ? addressText
                              : 'تم تحديد الموقع'),
                    style: VendorTextStyles.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.chevron_left),
              ],
            ),
          ),
        ),
        if (latitude != null && longitude != null) ...[
          const SizedBox(height: 8),
          Text(
            'Lat: ${latitude!.toStringAsFixed(5)}  |  '
            'Lng: ${longitude!.toStringAsFixed(5)}',
            style: VendorTextStyles.bodySmall,
            textDirection: TextDirection.ltr,
          ),
        ],
      ],
    );
  }
}
