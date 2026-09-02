import 'package:flutter/material.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';
import '../../domain/entities/vendor_profile.dart';

class VendorProfileInfoSection extends StatelessWidget {
  final VendorProfile profile;

  const VendorProfileInfoSection({super.key, required this.profile});

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
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('بيانات التواصل والمتجر', style: VendorTextStyles.headingSmall),
          const SizedBox(height: 16),
          if (profile.phoneNumber.isNotEmpty)
            _InfoTile(
              icon: Icons.phone_outlined,
              title: 'رقم الهاتف',
              value: profile.phoneNumber,
            ),
          if (profile.whatsappNumber != null &&
              profile.whatsappNumber!.isNotEmpty)
            _InfoTile(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'رقم الواتساب',
              value: profile.whatsappNumber!,
            ),
          if (profile.email.isNotEmpty)
            _InfoTile(
              icon: Icons.email_outlined,
              title: 'البريد الإلكتروني',
              value: profile.email,
            ),
          if (profile.addressText.isNotEmpty)
            _InfoTile(
              icon: Icons.location_on_outlined,
              title: 'العنوان',
              value: profile.addressText,
            ),
          _InfoTile(
            icon: Icons.local_shipping_outlined,
            title: 'رسوم التوصيل',
            value: '${profile.deliveryFee.toStringAsFixed(2)} د.أ',
          ),
          _InfoTile(
            icon: Icons.shopping_bag_outlined,
            title: 'الحد الأدنى للطلب',
            value: '${profile.minimumOrder.toStringAsFixed(2)} د.أ',
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: VendorColors.primary),
          const SizedBox(width: 12),
          Text(
            '$title:',
            style: VendorTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: VendorColors.textSecondary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: VendorTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
