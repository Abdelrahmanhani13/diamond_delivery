import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/app_button.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../domain/entities/address_domain_entity.dart';
import '../controller/add_edit_address_cubit/add_edit_address_cubit.dart';
import '../controller/add_edit_address_cubit/add_edit_address_state.dart';
import '../../../lookup/presentation/manager/lookup_cubit.dart';
import '../../../lookup/domain/entities/lookup_item.dart';
import '../../domain/entities/geocoded_address_entity_representing_a_reverse_forward_geocoding_result.dart';

import 'widgets/map_picker_preview.dart';
import 'widgets/address_form_section.dart';

/// Add / Edit Address screen — shared UI for both add and edit flows.
///
/// Fix notes (see chat discussion):
/// - "Area" is no longer a broken/mocked lookup dropdown. The backend
///   models it as free text (`areaText`), so it's a plain text field now,
///   pre-filled from the reverse-geocode result when available.
/// - Submitting without a location selected on the map is now blocked
///   (previously silently saved lat/lng as 0.0, 0.0).
/// - Picking a location on the map now attempts a best-effort match of
///   the returned country name against the Country lookup list.
/// - FIX: split into a Stateless outer widget (owns the MultiBlocProvider)
///   and a Stateful inner `_AddEditAddressBody` (owns all logic + UI).
class AddEditAddressView extends StatelessWidget {
  const AddEditAddressView({super.key, this.isEditing = false, this.address});

  final bool isEditing;
  final Address? address;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AddEditAddressCubit>()),
        BlocProvider(
          create: (_) => getIt<LookupCubit>()
            ..fetchCountries()
            ..fetchAddressTypes(),
        ),
      ],
      child: _AddEditAddressBody(isEditing: isEditing, address: address),
    );
  }
}

class _AddEditAddressBody extends StatefulWidget {
  const _AddEditAddressBody({required this.isEditing, this.address});

  final bool isEditing;
  final Address? address;

  @override
  State<_AddEditAddressBody> createState() => _AddEditAddressBodyState();
}

class _AddEditAddressBodyState extends State<_AddEditAddressBody> {
  late final TextEditingController _labelController;
  late final TextEditingController _detailsController;
  late final TextEditingController _buildingController;
  late final TextEditingController _areaController;
  double? _selectedLat;
  double? _selectedLng;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.address?.label ?? '');
    _detailsController = TextEditingController(
      text: widget.address?.street ?? '',
    );
    _buildingController = TextEditingController(
      text: widget.address?.buildingNumber ?? '',
    );
    _areaController = TextEditingController(
      text: widget.address?.areaText ?? '',
    );
    _selectedLat = widget.address?.latitude;
    _selectedLng = widget.address?.longitude;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _detailsController.dispose();
    _buildingController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  /// Best-effort match of a free-text name (from Nominatim) against a
  /// lookup list's nameEn/nameAr.
  LookupItem? _findMatch(String? name, List<LookupItem> items) {
    if (name == null || name.trim().isEmpty || items.isEmpty) return null;
    final normalized = name.trim().toLowerCase();

    for (final item in items) {
      if (item.nameEn.trim().toLowerCase() == normalized ||
          item.nameAr.trim().toLowerCase() == normalized) {
        return item;
      }
    }
    for (final item in items) {
      final en = item.nameEn.trim().toLowerCase();
      final ar = item.nameAr.trim().toLowerCase();
      if ((en.isNotEmpty &&
              (en.contains(normalized) || normalized.contains(en))) ||
          (ar.isNotEmpty &&
              (ar.contains(normalized) || normalized.contains(ar)))) {
        return item;
      }
    }
    return null;
  }

  Future<void> _openLocationPicker(BuildContext context) async {
    final result = await context.push(AppRoutes.locationPicker);
    if (result == null || result is! GeocodedAddress) return;
    if (!context.mounted) return;

    setState(() {
      _selectedLat = result.latitude;
      _selectedLng = result.longitude;
      if (_detailsController.text.isEmpty && result.street.isNotEmpty) {
        _detailsController.text = result.street;
      }
      if (_areaController.text.isEmpty && result.area.isNotEmpty) {
        _areaController.text = result.area;
      }
    });

    final lookupCubit = context.read<LookupCubit>();
    final matchedCountry = _findMatch(
      result.country,
      lookupCubit.state.countries,
    );
    if (matchedCountry != null &&
        lookupCubit.state.selectedCountry?.id != matchedCountry.id) {
      await lookupCubit.selectCountry(matchedCountry);
    }
  }

  void _onSubmit(BuildContext context) {
    final lookupState = context.read<LookupCubit>().state;

    if (lookupState.selectedCountry == null ||
        lookupState.selectedCity == null ||
        _labelController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء تعبئة الحقول الإلزامية واختيار الموقع.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedLat == null || _selectedLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('من فضلك حدد موقعك على الخريطة أولاً.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final addressToSubmit = Address(
      id: widget.isEditing && widget.address != null
          ? widget.address!.id
          : '',
      label: _labelController.text,
      countryId: lookupState.selectedCountry?.id ?? '',
      governorateId: lookupState.selectedGovernorate?.id ?? '',
      cityId: lookupState.selectedCity?.id ?? '',
      addressTypeId: lookupState.selectedAddressType?.id ?? '',
      areaText: _areaController.text,
      street: _detailsController.text,
      buildingNumber: _buildingController.text,
      floorNumber: widget.address?.floorNumber ?? '',
      apartmentNumber: widget.address?.apartmentNumber ?? '',
      landmark: widget.address?.landmark ?? '',
      notes: widget.address?.notes,
      latitude: _selectedLat!,
      longitude: _selectedLng!,
      isDefault: widget.address?.isDefault ?? false,
    );
    context.read<AddEditAddressCubit>().submit(addressToSubmit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: widget.isEditing ? context.tr('editAddress') : context.tr('addAddress'),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        children: [
          MapPickerPreview(
            isLocationSelected: _selectedLat != null,
            onTap: () => _openLocationPicker(context),
          ),
          SizedBox(height: 24.h),
          AddressFormSection(
            labelController: _labelController,
            areaController: _areaController,
            detailsController: _detailsController,
            buildingController: _buildingController,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: BlocConsumer<AddEditAddressCubit, AddEditAddressState>(
            listener: (context, state) {
              if (state is AddEditAddressSuccess) {
                context.pop(state.address);
              } else if (state is AddEditAddressError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return AppButton(
                label: widget.isEditing
                    ? context.tr('editAddress')
                    : context.tr('confirm'),
                icon: Icons.check_rounded,
                isLoading: state is AddEditAddressLoading,
                onPressed: () => _onSubmit(context),
              );
            },
          ),
        ),
      ),
    );
  }
}
