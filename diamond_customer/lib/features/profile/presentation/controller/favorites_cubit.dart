import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../stores/domain/entities/vendor.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/usecases/favorites_use_cases.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavoriteVendorsUseCase getFavoriteVendorsUseCase;
  final GetFavoriteProductsUseCase getFavoriteProductsUseCase;
  final AddFavoriteVendorUseCase addFavoriteVendorUseCase;
  final RemoveFavoriteVendorUseCase removeFavoriteVendorUseCase;
  final AddFavoriteProductUseCase addFavoriteProductUseCase;
  final RemoveFavoriteProductUseCase removeFavoriteProductUseCase;

  FavoritesCubit({
    required this.getFavoriteVendorsUseCase,
    required this.getFavoriteProductsUseCase,
    required this.addFavoriteVendorUseCase,
    required this.removeFavoriteVendorUseCase,
    required this.addFavoriteProductUseCase,
    required this.removeFavoriteProductUseCase,
  }) : super(FavoritesInitial());

  int _currentVendorPage = 1;
  int _currentProductPage = 1;
  static const int _pageSize = 20;
  
  List<Vendor> _currentVendors = [];
  bool _vendorHasReachedMax = false;
  bool _isFetchingVendors = false;

  List<Product> _currentProducts = [];
  bool _productHasReachedMax = false;
  bool _isFetchingProducts = false;

  Future<void> fetchFavoriteVendors({bool refresh = false}) async {
    if (_isFetchingVendors) return;
    if (refresh) {
      _currentVendorPage = 1;
      _currentVendors = [];
      _vendorHasReachedMax = false;
      emit(FavoriteVendorsLoading());
    } else if (_vendorHasReachedMax) {
      return;
    }

    _isFetchingVendors = true;

    final result = await getFavoriteVendorsUseCase(page: _currentVendorPage, pageSize: _pageSize);

    result.fold(
      (failure) {
        emit(FavoriteVendorsError(failure.message));
        _isFetchingVendors = false;
      },
      (newVendors) {
        _currentVendorPage++;
        if (newVendors.length < _pageSize) {
          _vendorHasReachedMax = true;
        }
        _currentVendors.addAll(newVendors);
        emit(FavoriteVendorsLoaded(
          vendors: List.from(_currentVendors),
          hasReachedMax: _vendorHasReachedMax,
        ));
        _isFetchingVendors = false;
      },
    );
  }

  Future<void> fetchFavoriteProducts({bool refresh = false}) async {
    if (_isFetchingProducts) return;
    if (refresh) {
      _currentProductPage = 1;
      _currentProducts = [];
      _productHasReachedMax = false;
      emit(FavoriteProductsLoading());
    } else if (_productHasReachedMax) {
      return;
    }

    _isFetchingProducts = true;

    final result = await getFavoriteProductsUseCase(page: _currentProductPage, pageSize: _pageSize);

    result.fold(
      (failure) {
        emit(FavoriteProductsError(failure.message));
        _isFetchingProducts = false;
      },
      (newProducts) {
        _currentProductPage++;
        if (newProducts.length < _pageSize) {
          _productHasReachedMax = true;
        }
        _currentProducts.addAll(newProducts);
        emit(FavoriteProductsLoaded(
          products: List.from(_currentProducts),
          hasReachedMax: _productHasReachedMax,
        ));
        _isFetchingProducts = false;
      },
    );
  }

  Future<void> toggleFavoriteVendor(String vendorId, bool isCurrentlyFavorite) async {
    // Optimistic Update can be done here if needed
    final result = isCurrentlyFavorite
        ? await removeFavoriteVendorUseCase(vendorId)
        : await addFavoriteVendorUseCase(vendorId);

    result.fold(
      (failure) => emit(FavoriteActionError(failure.message)),
      (_) {
        emit(FavoriteActionSuccess());
        // Optional: Refresh vendors
      },
    );
  }

  Future<void> toggleFavoriteProduct(String productId, bool isCurrentlyFavorite) async {
    final result = isCurrentlyFavorite
        ? await removeFavoriteProductUseCase(productId)
        : await addFavoriteProductUseCase(productId);

    result.fold(
      (failure) => emit(FavoriteActionError(failure.message)),
      (_) {
        emit(FavoriteActionSuccess());
        // Optional: Refresh products
      },
    );
  }
}
