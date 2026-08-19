// presentation/controller/products_cubit/vendor_products_state.dart
import '../../../domain/entities/vendor_product.dart';

abstract class VendorProductsState {}

class VendorProductsInitial extends VendorProductsState {}

class VendorProductsLoading extends VendorProductsState {}

class VendorProductsLoaded extends VendorProductsState {
  final List<VendorProduct> products;
  final bool hasReachedMax;

  VendorProductsLoaded({required this.products, required this.hasReachedMax});

  VendorProductsLoaded copyWith({
    List<VendorProduct>? products,
    bool? hasReachedMax,
  }) {
    return VendorProductsLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class VendorProductsError extends VendorProductsState {
  final String message;
  VendorProductsError(this.message);
}
