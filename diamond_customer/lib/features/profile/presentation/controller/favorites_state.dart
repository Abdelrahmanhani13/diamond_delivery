import 'package:equatable/equatable.dart';
import '../../../stores/domain/entities/vendor.dart';
import '../../../products/domain/entities/product.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoriteVendorsLoading extends FavoritesState {}

class FavoriteVendorsLoaded extends FavoritesState {
  final List<Vendor> vendors;
  final bool hasReachedMax;
  const FavoriteVendorsLoaded({
    required this.vendors,
    this.hasReachedMax = false,
  });
  @override
  List<Object?> get props => [vendors, hasReachedMax];
}

class FavoriteVendorsError extends FavoritesState {
  final String message;
  const FavoriteVendorsError(this.message);
  @override
  List<Object?> get props => [message];
}

class FavoriteProductsLoading extends FavoritesState {}

class FavoriteProductsLoaded extends FavoritesState {
  final List<Product> products;
  final bool hasReachedMax;
  const FavoriteProductsLoaded({
    required this.products,
    this.hasReachedMax = false,
  });
  @override
  List<Object?> get props => [products, hasReachedMax];
}

class FavoriteProductsError extends FavoritesState {
  final String message;
  const FavoriteProductsError(this.message);
  @override
  List<Object?> get props => [message];
}

class FavoriteActionLoading extends FavoritesState {}

class FavoriteActionSuccess extends FavoritesState {}

class FavoriteActionError extends FavoritesState {
  final String message;
  const FavoriteActionError(this.message);
  @override
  List<Object?> get props => [message];
}
