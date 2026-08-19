import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../lookup/presentation/manager/lookup_cubit.dart';
import '../../../../lookup/presentation/manager/lookup_state.dart';
import 'lookup_dropdown_field.dart';

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
        color: context.surfaceColor,
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
          final countryText = lookupState.selectedCountry != null
              ? context.localizedText(
                  lookupState.selectedCountry!.nameAr,
                  lookupState.selectedCountry!.nameEn,
                )
              : (context.isArabic ? 'مصر' : 'Egypt');

          final governorateText = lookupState.selectedGovernorate != null
              ? context.localizedText(
                  lookupState.selectedGovernorate!.nameAr,
                  lookupState.selectedGovernorate!.nameEn,
                )
              : (context.isArabic ? 'القاهرة' : 'Cairo');

          final cityText = lookupState.selectedCity != null
              ? context.localizedText(
                  lookupState.selectedCity!.nameAr,
                  lookupState.selectedCity!.nameEn,
                )
              : (context.isArabic ? 'القاهرة' : 'Cairo');

          return Column(
            children: [
              AppTextField(
                controller: labelController,
                label: context.isArabic ? 'اسم هذا العنوان' : 'Address Name',
                hint: context.isArabic ? 'المنزل، العمل، الاستراحة...' : 'Home, Office...',
                prefixIcon: Icons.bookmark_border_rounded,
              ),
              SizedBox(height: 16.h),
              LookupDropdownField(
                label: context.isArabic ? 'نوع العنوان' : 'Address Type',
                items: lookupState.addressTypes,
                value: lookupState.selectedAddressType,
                isLoading: lookupState.isLoadingAddressTypes,
                onChanged: (item) =>
                    context.read<LookupCubit>().selectAddressType(item!),
              ),
              SizedBox(height: 16.h),

              // Fixed Read-Only Country
              AppTextField(
                controller: TextEditingController(text: countryText),
                label: context.isArabic ? 'الدولة' : 'Country',
                enabled: false,
                prefixIcon: Icons.flag_outlined,
              ),
              SizedBox(height: 16.h),

              // Fixed Read-Only Governorate
              AppTextField(
                controller: TextEditingController(text: governorateText),
                label: context.isArabic ? 'المحافظة / المنطقة' : 'Governorate',
                enabled: false,
                prefixIcon: Icons.location_city_outlined,
              ),
              SizedBox(height: 16.h),

              // Fixed Read-Only City
              AppTextField(
                controller: TextEditingController(text: cityText),
                label: context.isArabic ? 'المدينة' : 'City',
                enabled: false,
                prefixIcon: Icons.location_on_outlined,
              ),
              SizedBox(height: 16.h),

              AppTextField(
                controller: areaController,
                label: context.isArabic ? 'الحي / المنطقة' : 'District / Area',
                hint: context.isArabic ? 'مثال: المعادي، وسط البلد...' : 'e.g., Maadi, Downtown...',
                prefixIcon: Icons.map_outlined,
              ),
              SizedBox(height: 16.h),
              AppTextField(
                controller: detailsController,
                label: context.isArabic ? 'تفاصيل الشارع' : 'Street Details',
                hint: context.isArabic ? 'مثال: شارع الملك فيصل' : 'e.g., Main Street',
                prefixIcon: Icons.location_on_outlined,
              ),
              SizedBox(height: 16.h),
              AppTextField(
                controller: buildingController,
                label: context.isArabic ? 'رقم المبنى / الشقة / تفاصيل إضافية' : 'Building / Apt / Floor Details',
                hint: context.isArabic ? 'مثال: مبنى 14، شقة 5، الدور الثاني' : 'e.g., Bldg 14, Apt 5',
                prefixIcon: Icons.home_work_outlined,
              ),
            ],
          );
        },
      ),
    );
  }
}
