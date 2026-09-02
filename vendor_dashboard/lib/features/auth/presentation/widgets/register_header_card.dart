import 'package:flutter/material.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';

class RegisterHeaderCard extends StatelessWidget {
  const RegisterHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: VendorColors.primaryLight,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.store_rounded,
            size: 48,
            color: VendorColors.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'أنشئ متجرك الآن',
            style: VendorTextStyles.headingMedium.copyWith(
              color: VendorColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'أدخل بيانات المتجر وموقعه للبدء في البيع',
            style: VendorTextStyles.bodySmall.copyWith(
              color: VendorColors.primaryDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
