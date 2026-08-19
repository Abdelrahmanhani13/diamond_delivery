import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/vendor.dart';
import '../../domain/usecases/stores_use_cases.dart';
import 'vendor_list_state.dart';

class VendorListCubit extends Cubit<VendorListState> {
  final GetVendorsUseCase getVendorsUseCase;
  final GetNearbyVendorsUseCase getNearbyVendorsUseCase;

  VendorListCubit({
    required this.getVendorsUseCase,
    required this.getNearbyVendorsUseCase,
  }) : super(VendorListInitial());

  int _currentPage = 1;
  static const int _pageSize = 20;
  List<Vendor> _currentVendors = [];
  bool _isFetching = false;
  bool _hasReachedMax = false;

  Future<void> fetchVendors({
    bool refresh = false,
    String? search,
    String? categoryId,
    bool? openNow,
    double? rating,
    String? sortBy,
    bool isNearby = false,
    double? latitude,
    double? longitude,
    double radiusKm = 10.0,
  }) async {
    if (_isFetching) return;
    if (refresh) {
      _currentPage = 1;
      _currentVendors = [];
      _hasReachedMax = false;
      emit(VendorListLoading());
    } else if (_hasReachedMax) {
      return;
    }

    _isFetching = true;

    final result = isNearby && latitude != null && longitude != null
        ? await getNearbyVendorsUseCase(
            latitude: latitude,
            longitude: longitude,
            radiusKm: radiusKm,
            page: _currentPage,
            pageSize: _pageSize,
          )
        : await getVendorsUseCase(
            page: _currentPage,
            pageSize: _pageSize,
            search: search,
            categoryId: categoryId,
            openNow: openNow,
            rating: rating,
            sortBy: sortBy,
          );

    result.fold(
      (failure) {
        emit(VendorListError(failure.message));
        _isFetching = false;
      },
      (newVendors) {
        _currentPage++;
        if (newVendors.length < _pageSize) {
          _hasReachedMax = true;
        }
        _currentVendors.addAll(newVendors);
        emit(VendorListLoaded(
          vendors: List.from(_currentVendors),
          hasReachedMax: _hasReachedMax,
        ));
        _isFetching = false;
      },
    );
  }
}
