import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../lookup/presentation/manager/lookup_cubit.dart';
import '../../../../lookup/presentation/manager/lookup_state.dart';
import 'lookup_dropdown_field.dart';

/// The form section of the Add/Edit Address screen.
/// Contains all text fields and lookup dropdowns wrapped in a styled card.
class AddressFormSection extends StatelessWidget {
  const AddressFormSection({
    super.key,
    required this.labelController,
    required this.areaController,
    required this.detailsController,
    required this.buildingController,
  });

  final TextEditingController labelController;
  final TextEditingController areaController;
  final TextEditingController detailsController;
  final TextEditingController buildingController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: BlocBuilder<LookupCubit, LookupState>(
        builder: (context, lookupState) {
          return Column(
            children: [
              AppTextField(
                controller: labelController,
                label: 'اسم هذا العنوان',
                hint: 'المنزل، العمل، الاستراحة...',
                prefixIcon: Icons.bookmark_border_rounded,
              ),
              SizedBox(height: 16.h),
              LookupDropdownField(
                label: 'نوع العنوان',
                items: lookupState.addressTypes,
                value: lookupState.selectedAddressType,
                isLoading: lookupState.isLoadingAddressTypes,
                onChanged: (item) =>
                    context.read<LookupCubit>().selectAddressType(item!),
              ),
              SizedBox(height: 16.h),
              LookupDropdownField(
                label: 'الدولة',
                items: lookupState.countries,
                value: lookupState.selectedCountry,
                isLoading: lookupState.isLoadingCountries,
                onChanged: (item) =>
                    context.read<LookupCubit>().selectCountry(item!),
              ),
              SizedBox(height: 16.h),
              LookupDropdownField(
                label: 'المحافظة / المنطقة',
                items: lookupState.governorates,
                value: lookupState.selectedGovernorate,
                isLoading: lookupState.isLoadingGovernorates,
                enabled: lookupState.selectedCountry != null,
                onChanged: (item) =>
                    context.read<LookupCubit>().selectGovernorate(item!),
              ),
              SizedBox(height: 16.h),
              LookupDropdownField(
                label: 'المدينة',
                items: lookupState.cities,
                value: lookupState.selectedCity,
                isLoading: lookupState.isLoadingCities,
                enabled: lookupState.selectedGovernorate != null,
                onChanged: (item) =>
                    context.read<LookupCubit>().selectCity(item!),
              ),
              SizedBox(height: 16.h),
              AppTextField(
                controller: areaController,
                label: 'الحي / المنطقة',
                hint: 'مثال: المعادي، وسط البلد...',
                prefixIcon: Icons.map_outlined,
              ),
              SizedBox(height: 16.h),
              AppTextField(
                controller: detailsController,
                label: 'تفاصيل الشارع',
                hint: 'مثال: شارع الملك فيصل',
                prefixIcon: Icons.location_on_outlined,
              ),
              SizedBox(height: 16.h),
              AppTextField(
                controller: buildingController,
                label: 'رقم المبنى / الشقة / تفاصيل إضافية',
                hint: 'مثال: مبنى 14، شقة 5، الدور الثاني',
                prefixIcon: Icons.home_work_outlined,
              ),
            ],
          );
        },
      ),
    );
  }
}
