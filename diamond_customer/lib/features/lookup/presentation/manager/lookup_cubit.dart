import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/lookup_item.dart';
import '../../domain/usecases/lookup_usecases.dart';
import 'lookup_state.dart';

class LookupCubit extends Cubit<LookupState> {
  final GetCountriesUseCase _getCountriesUseCase;
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final GetCitiesUseCase _getCitiesUseCase;
  final GetAddressTypesUseCase _getAddressTypesUseCase;
  final GetGendersUseCase _getGendersUseCase;

  LookupCubit({
    required GetCountriesUseCase getCountriesUseCase,
    required GetGovernoratesUseCase getGovernoratesUseCase,
    required GetCitiesUseCase getCitiesUseCase,
    required GetAddressTypesUseCase getAddressTypesUseCase,
    required GetGendersUseCase getGendersUseCase,
  }) : _getCountriesUseCase = getCountriesUseCase,
       _getGovernoratesUseCase = getGovernoratesUseCase,
       _getCitiesUseCase = getCitiesUseCase,
       _getAddressTypesUseCase = getAddressTypesUseCase,
       _getGendersUseCase = getGendersUseCase,
       super(const LookupState());

  Future<void> fetchCountries() async {
    emit(state.copyWith(isLoadingCountries: true, clearError: true));
    final result = await _getCountriesUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingCountries: false, error: failure.message),
      ),
      (countries) =>
          emit(state.copyWith(isLoadingCountries: false, countries: countries)),
    );
  }

  Future<void> fetchAddressTypes() async {
    emit(state.copyWith(isLoadingAddressTypes: true, clearError: true));
    final result = await _getAddressTypesUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingAddressTypes: false, error: failure.message),
      ),
      (addressTypes) => emit(
        state.copyWith(
          isLoadingAddressTypes: false,
          addressTypes: addressTypes,
        ),
      ),
    );
  }

  Future<void> fetchGenders() async {
    emit(state.copyWith(isLoadingGenders: true, clearError: true));
    final result = await _getGendersUseCase();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoadingGenders: false, error: failure.message)),
      (genders) =>
          emit(state.copyWith(isLoadingGenders: false, genders: genders)),
    );
  }

  /// Cascading Logic: Selecting a Country
  Future<void> selectCountry(LookupItem country) async {
    emit(
      state.copyWith(
        selectedCountry: country,
        clearSelectedGovernorate: true,
        clearSelectedCity: true,
        governorates: const [],
        cities: const [],
        isLoadingGovernorates: true,
        clearError: true,
      ),
    );

    final result = await _getGovernoratesUseCase(country.id);
    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingGovernorates: false, error: failure.message),
      ),
      (governorates) => emit(
        state.copyWith(
          isLoadingGovernorates: false,
          governorates: governorates,
        ),
      ),
    );
  }

  /// Cascading Logic: Selecting a Governorate
  Future<void> selectGovernorate(LookupItem governorate) async {
    emit(
      state.copyWith(
        selectedGovernorate: governorate,
        clearSelectedCity: true,
        cities: const [],
        isLoadingCities: true,
        clearError: true,
      ),
    );

    final result = await _getCitiesUseCase(governorate.id);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoadingCities: false, error: failure.message)),
      (cities) => emit(state.copyWith(isLoadingCities: false, cities: cities)),
    );
  }

  /// Selecting a City (مفيش Areas بعد كده)
  void selectCity(LookupItem city) {
    emit(state.copyWith(selectedCity: city, clearError: true));
  }

  /// Select Address Type
  void selectAddressType(LookupItem type) {
    emit(state.copyWith(selectedAddressType: type));
  }

  /// Select Gender
  void selectGender(LookupItem gender) {
    emit(state.copyWith(selectedGender: gender));
  }
}
