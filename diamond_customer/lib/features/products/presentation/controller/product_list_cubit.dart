import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/products_use_cases.dart';
import 'product_list_state.dart';

class ProductListCubit extends Cubit<ProductListState> {
  final GetProductsUseCase getProductsUseCase;

  ProductListCubit(this.getProductsUseCase) : super(ProductListInitial());

  int _currentPage = 1;
  static const int _pageSize = 20;
  List<Product> _currentProducts = [];
  bool _isFetching = false;
  bool _hasReachedMax = false;

  Future<void> fetchProducts({
    bool refresh = false,
    String? search,
    String? vendorCategoryId,
    String? subCategoryId,
    String? vendorId,
    double? minPrice,
    double? maxPrice,
    int? sortBy,
  }) async {
    if (_isFetching) return;
    if (refresh) {
      _currentPage = 1;
      _currentProducts = [];
      _hasReachedMax = false;
      emit(ProductListLoading());
    } else if (_hasReachedMax) {
      return;
    }

    _isFetching = true;

    final result = await getProductsUseCase(
      page: _currentPage,
      pageSize: _pageSize,
      search: search,
      vendorCategoryId: vendorCategoryId,
      subCategoryId: subCategoryId,
      vendorId: vendorId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      sortBy: sortBy,
    );

    result.fold(
      (failure) {
        emit(ProductListError(failure.message));
        _isFetching = false;
      },
      (newProducts) {
        _currentPage++;
        if (newProducts.length < _pageSize) {
          _hasReachedMax = true;
        }
        _currentProducts.addAll(newProducts);
        emit(
          ProductListLoaded(
            products: List.from(_currentProducts),
            hasReachedMax: _hasReachedMax,
          ),
        );
        _isFetching = false;
      },
    );
  }
}
