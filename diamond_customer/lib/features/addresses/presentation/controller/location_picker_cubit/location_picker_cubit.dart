import 'dart:async';

import 'package:diamond_customer/features/addresses/domain/entities/coordinates_value_entity.dart';
import 'package:diamond_customer/features/addresses/domain/entities/geocoded_address_entity_representing_a_reverse_forward_geocoding_result.dart';
import 'package:diamond_customer/features/addresses/domain/usecases/get_current_location_use_case.dart';
import 'package:diamond_customer/features/addresses/domain/usecases/reverse_geocode_use_case.dart';
import 'package:diamond_customer/features/addresses/domain/usecases/search_address_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'location_picker_state.dart';

class LocationPickerCubit extends Cubit<LocationPickerState> {
  final GetCurrentLocationUseCase _getCurrentLocationUseCase;
  final ReverseGeocodeUseCase _reverseGeocodeUseCase;
  final SearchAddressUseCase _searchAddressUseCase;

  LocationPickerCubit(
    this._getCurrentLocationUseCase,
    this._reverseGeocodeUseCase,
    this._searchAddressUseCase,
  ) : super(LocationPickerInitial());

  Timer? _searchDebounce;

  /// بتتنادى أول ما الشاشة تفتح (لو مفيش موقع سابق اتبعت) عشان
  /// نحط البن على موقع المستخدم الحالي بدل نقطة عشوائية.
  Future<void> useCurrentLocation() async {
    emit(LocationPickerLoading());
    final locationResult = await _getCurrentLocationUseCase();
    // FIX: الـ await فوق ممكن ياخد وقت (permission dialog، GPS...)،
    // ولو المستخدم قفل الشاشة في الأثناء، الـ Cubit بيتقفل تلقائياً
    // (BlocProvider.dispose) والـ emit بعد كده بيرمي
    // "Bad state: Cannot emit new states after calling close".
    // isClosed بيتحقق إن الـ Cubit لسه حي قبل أي emit بعد أي await.
    if (isClosed) return;
    await locationResult.fold((failure) async {
      if (!isClosed) emit(LocationPickerError(failure.message));
    }, (coordinates) => _resolveAddress(coordinates));
  }

  /// بتتنادى كل ما المستخدم يسيب البن على نقطة جديدة على الخريطة.
  Future<void> updateSelectedPosition(Coordinates coordinates) async {
    await _resolveAddress(coordinates);
  }

  Future<void> _resolveAddress(Coordinates coordinates) async {
    final current = state;
    // لو عندنا حالة محمّلة بالفعل، بنحدّث الإحداثيات فوراً (عشان
    // البن يتحرك من غير تهنيج) ونستنى نتيجة الـ geocode بعد كده،
    // بدل ما نرجع لشاشة تحميل فاضية في كل تحريكة للخريطة.
    if (current is LocationPickerLoaded) {
      emit(current.copyWith(coordinates: coordinates));
    } else {
      emit(LocationPickerLoading());
    }

    final result = await _reverseGeocodeUseCase(coordinates);
    // FIX: نفس المشكلة — الـ reverseGeocode request ممكن يفضل شغال
    // (خصوصاً مع Nominatim اللي بياخد وقت) والمستخدم يقفل الشاشة
    // قبل ما يرد. لازم نتأكد إن الـ Cubit لسه مش مقفول قبل الـ emit.
    if (isClosed) return;
    result.fold(
      (failure) => emit(LocationPickerError(failure.message)),
      (address) => emit(
        LocationPickerLoaded(coordinates: coordinates, address: address),
      ),
    );
  }

  /// بحث نصي مع debounce بسيط — سياسة الاستخدام العادل عند Nominatim
  /// بتسمح بطلب واحد في الثانية بس، فمينفعش نضرب طلب مع كل حرف.
  void searchAddress(String query) {
    _searchDebounce?.cancel();
    final current = state;
    if (current is! LocationPickerLoaded) return;

    if (query.trim().length < 3) {
      emit(current.copyWith(searchResults: const [], isSearching: false));
      return;
    }

    emit(current.copyWith(isSearching: true));
    _searchDebounce = Timer(const Duration(milliseconds: 600), () async {
      final result = await _searchAddressUseCase(query.trim());
      // FIX: التايمر ده بيبقى شغال حتى لو الشاشة اتقفلت والـ Cubit
      // اتقفل، فنفس مشكلة الـ emit-after-close ممكن تحصل هنا كمان.
      if (isClosed) return;
      final latest = state;
      if (latest is! LocationPickerLoaded) return;
      result.fold(
        (_) =>
            emit(latest.copyWith(searchResults: const [], isSearching: false)),
        (results) =>
            emit(latest.copyWith(searchResults: results, isSearching: false)),
      );
    });
  }

  void selectSearchResult(GeocodedAddress result) {
    if (isClosed) return;
    emit(
      LocationPickerLoaded(
        coordinates: Coordinates(
          latitude: result.latitude,
          longitude: result.longitude,
        ),
        address: result,
        searchResults: const [],
      ),
    );
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
