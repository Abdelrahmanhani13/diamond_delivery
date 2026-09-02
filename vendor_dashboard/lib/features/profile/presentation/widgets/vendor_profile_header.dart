import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';
import '../../../../core/utils/localized_entity_extension.dart';
import '../../domain/entities/vendor_profile.dart';

class VendorProfileHeader extends StatelessWidget {
  final VendorProfile profile;
  final bool isUpdatingStatus;
  final ValueChanged<bool> onToggleStatus;
  final ValueChanged<File> onLogoPicked;
  final ValueChanged<File> onCoverPicked;

  const VendorProfileHeader({
    super.key,
    required this.profile,
    required this.isUpdatingStatus,
    required this.onToggleStatus,
    required this.onLogoPicked,
    required this.onCoverPicked,
  });

  Future<void> _pickImage(
    ImagePicker picker,
    ValueChanged<File> onPicked,
  ) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      onPicked(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();

    final primaryName = context.isArabic
        ? profile.nameArabic
        : (profile.nameEnglish.isNotEmpty
              ? profile.nameEnglish
              : profile.nameArabic);

    final secondaryName = context.isArabic
        ? profile.nameEnglish
        : profile.nameArabic;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Cover Image
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: VendorColors.primaryLight,
                image: profile.coverUrl != null && profile.coverUrl!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(profile.coverUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: CircleAvatar(
                      backgroundColor: VendorColors.surface.withValues(
                        alpha: 0.8,
                      ),
                      radius: 18,
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt_rounded,
                          size: 18,
                          color: VendorColors.primary,
                        ),
                        onPressed: () => _pickImage(picker, onCoverPicked),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Logo Image
            Positioned(
              bottom: -40,
              right: 20,
              child: Stack(
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      color: VendorColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: VendorColors.surface, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: VendorColors.shadow,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      image:
                          profile.logoUrl != null && profile.logoUrl!.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(profile.logoUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: profile.logoUrl == null || profile.logoUrl!.isEmpty
                        ? const Icon(
                            Icons.storefront_rounded,
                            size: 40,
                            color: VendorColors.primary,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: CircleAvatar(
                      backgroundColor: VendorColors.primary,
                      radius: 14,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.camera_alt_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                        onPressed: () => _pickImage(picker, onLogoPicked),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 48),

        // Vendor Info Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(primaryName, style: VendorTextStyles.headingLarge),
                    if (secondaryName.isNotEmpty &&
                        secondaryName != primaryName)
                      Text(
                        secondaryName,
                        style: VendorTextStyles.bodyMedium.copyWith(
                          color: VendorColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        profile.isOpen
                            ? context.tr('storeIsOpen')
                            : context.tr('storeIsClosed'),
                        style: VendorTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: profile.isOpen
                              ? VendorColors.success
                              : VendorColors.error,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Switch.adaptive(
                        value: profile.isOpen,
                        activeThumbColor: VendorColors.success,
                        onChanged: isUpdatingStatus ? null : onToggleStatus,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
