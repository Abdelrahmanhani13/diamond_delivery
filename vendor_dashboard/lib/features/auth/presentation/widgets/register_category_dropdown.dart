import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';
import '../../../../core/utils/localized_entity_extension.dart';
import '../../../profile/domain/entities/vendor_category.dart';
import '../controller/vendor_categories_cubit/vendor_categories_cubit.dart';
import '../controller/vendor_categories_cubit/vendor_categories_state.dart';

class RegisterCategoryDropdown extends StatelessWidget {
  final String? selectedCategoryId;
  final ValueChanged<VendorCategory> onCategorySelected;

  const RegisterCategoryDropdown({
    super.key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('selectCategory'),
          style: VendorTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<VendorCategoriesCubit, VendorCategoriesState>(
          builder: (context, state) {
            if (state is VendorCategoriesLoading) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: VendorColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: VendorColors.border),
                ),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: VendorColors.primary,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text('جاري تحميل الفئات...'),
                  ],
                ),
              );
            }

            if (state is VendorCategoriesError) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: VendorColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: VendorColors.error),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: VendorColors.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.message,
                        style: VendorTextStyles.bodySmall.copyWith(
                          color: VendorColors.error,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.refresh,
                        color: VendorColors.error,
                      ),
                      onPressed: () => context
                          .read<VendorCategoriesCubit>()
                          .loadCategories(),
                    ),
                  ],
                ),
              );
            }

            if (state is VendorCategoriesLoaded) {
              final categories = state.categories;

              VendorCategory? selectedCategory;
              if (selectedCategoryId != null) {
                final matches = categories.where(
                  (c) => c.id == selectedCategoryId,
                );
                if (matches.isNotEmpty) {
                  selectedCategory = matches.first;
                }
              }

              return DropdownButtonFormField<VendorCategory>(
                initialValue: selectedCategory,
                isExpanded: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.category_outlined,
                    color: VendorColors.primary,
                  ),
                  hintText: context.tr('selectCategoryHint'),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: VendorColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: VendorColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: VendorColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
                items: categories.map((cat) {
                  return DropdownMenuItem<VendorCategory>(
                    value: cat,
                    child: Text(
                      cat.getLocalizedName(context),
                      style: VendorTextStyles.bodyMedium,
                    ),
                  );
                }).toList(),
                onChanged: (cat) {
                  if (cat != null) {
                    onCategorySelected(cat);
                  }
                },
                validator: (value) {
                  if (value == null &&
                      (selectedCategoryId == null ||
                          selectedCategoryId!.isEmpty)) {
                    return context.tr('selectCategoryFirst');
                  }
                  return null;
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
