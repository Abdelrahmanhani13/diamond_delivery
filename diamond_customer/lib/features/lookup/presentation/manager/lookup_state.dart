import 'package:equatable/equatable.dart';
import '../../domain/entities/lookup_item.dart';

class LookupState extends Equatable {
  // Lists
  final List<LookupItem> countries;
  final List<LookupItem> governorates;
  final List<LookupItem> cities;
  final List<LookupItem> addressTypes;
  final List<LookupItem> genders;

  // Selected Items
  final LookupItem? selectedCountry;
  final LookupItem? selectedGovernorate;
  final LookupItem? selectedCity;
  final LookupItem? selectedAddressType;
  final LookupItem? selectedGender;

  // Loading States
  final bool isLoadingCountries;
  final bool isLoadingGovernorates;
  final bool isLoadingCities;
  final bool isLoadingAddressTypes;
  final bool isLoadingGenders;

  // Errors
  final String? error;

  const LookupState({
    this.countries = const [],
    this.governorates = const [],
    this.cities = const [],
    this.addressTypes = const [],
    this.genders = const [],
    this.selectedCountry,
    this.selectedGovernorate,
    this.selectedCity,
    this.selectedAddressType,
    this.selectedGender,
    this.isLoadingCountries = false,
    this.isLoadingGovernorates = false,
    this.isLoadingCities = false,
    this.isLoadingAddressTypes = false,
    this.isLoadingGenders = false,
    this.error,
  });

  LookupState copyWith({
    List<LookupItem>? countries,
    List<LookupItem>? governorates,
    List<LookupItem>? cities,
    List<LookupItem>? addressTypes,
    List<LookupItem>? genders,
    LookupItem? selectedCountry,
    LookupItem? selectedGovernorate,
    LookupItem? selectedCity,
    LookupItem? selectedAddressType,
    LookupItem? selectedGender,
    bool? isLoadingCountries,
    bool? isLoadingGovernorates,
    bool? isLoadingCities,
    bool? isLoadingAddressTypes,
    bool? isLoadingGenders,
    String? error,
    bool clearSelectedCountry = false,
    bool clearSelectedGovernorate = false,
    bool clearSelectedCity = false,
    bool clearSelectedAddressType = false,
    bool clearSelectedGender = false,
    bool clearError = false,
  }) {
    return LookupState(
      countries: countries ?? this.countries,
      governorates: governorates ?? this.governorates,
      cities: cities ?? this.cities,
      addressTypes: addressTypes ?? this.addressTypes,
      genders: genders ?? this.genders,
      selectedCountry: clearSelectedCountry
          ? null
          : (selectedCountry ?? this.selectedCountry),
      selectedGovernorate: clearSelectedGovernorate
          ? null
          : (selectedGovernorate ?? this.selectedGovernorate),
      selectedCity: clearSelectedCity
          ? null
          : (selectedCity ?? this.selectedCity),
      selectedAddressType: clearSelectedAddressType
          ? null
          : (selectedAddressType ?? this.selectedAddressType),
      selectedGender: clearSelectedGender
          ? null
          : (selectedGender ?? this.selectedGender),
      isLoadingCountries: isLoadingCountries ?? this.isLoadingCountries,
      isLoadingGovernorates:
          isLoadingGovernorates ?? this.isLoadingGovernorates,
      isLoadingCities: isLoadingCities ?? this.isLoadingCities,
      isLoadingAddressTypes:
          isLoadingAddressTypes ?? this.isLoadingAddressTypes,
      isLoadingGenders: isLoadingGenders ?? this.isLoadingGenders,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
    countries,
    governorates,
    cities,
    addressTypes,
    genders,
    selectedCountry,
    selectedGovernorate,
    selectedCity,
    selectedAddressType,
    selectedGender,
    isLoadingCountries,
    isLoadingGovernorates,
    isLoadingCities,
    isLoadingAddressTypes,
    isLoadingGenders,
    error,
  ];
}
