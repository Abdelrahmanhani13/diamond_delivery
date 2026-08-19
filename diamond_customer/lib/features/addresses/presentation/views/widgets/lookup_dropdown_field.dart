import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../lookup/domain/entities/lookup_item.dart';

class LookupDropdownField extends StatelessWidget {
  const LookupDropdownField({
    super.key,
    required this.label,
    required this.items,
    this.value,
    required this.isLoading,
    this.enabled = true,
    required this.onChanged,
  });

  final String label;
  final List<LookupItem> items;
  final LookupItem? value;
  final bool isLoading;
  final bool enabled;
  final ValueChanged<LookupItem?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<LookupItem>(
      key: ValueKey('$label-${value?.id}'),
      initialValue: value,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e.nameAr)))
          .toList(),
      onChanged: enabled && !isLoading ? onChanged : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        suffixIcon: isLoading
            ? const Padding(
                padding: EdgeInsets.all(12.0),
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : null,
      ),
    );
  }
}
