import '../../../../core/utils/either.dart';
import '../../../../core/errors/failures.dart';
import '../../../stores/domain/entities/vendor.dart';
import '../../../products/domain/entities/product.dart';
import '../repos/favorites_repo.dart';

class GetFavoriteVendorsUseCase {
  final FavoritesRepo repo;

  GetFavoriteVendorsUseCase(this.repo);

  Future<Either<Failure, List<Vendor>>> call({required int page, required int pageSize}) async {
    return await repo.getFavoriteVendors(page: page, pageSize: pageSize);
  }
}

class GetFavoriteProductsUseCase {
  final FavoritesRepo repo;

  GetFavoriteProductsUseCase(this.repo);

  Future<Either<Failure, List<Product>>> call({required int page, required int pageSize}) async {
    return await repo.getFavoriteProducts(page: page, pageSize: pageSize);
  }
}

class AddFavoriteVendorUseCase {
  final FavoritesRepo repo;

  AddFavoriteVendorUseCase(this.repo);

  Future<Either<Failure, void>> call(String vendorId) async {
    return await repo.addFavoriteVendor(vendorId);
  }
}

class RemoveFavoriteVendorUseCase {
  final FavoritesRepo repo;

  RemoveFavoriteVendorUseCase(this.repo);

  Future<Either<Failure, void>> call(String vendorId) async {
    return await repo.removeFavoriteVendor(vendorId);
  }
}

class AddFavoriteProductUseCase {
  final FavoritesRepo repo;

  AddFavoriteProductUseCase(this.repo);

  Future<Either<Failure, void>> call(String productId) async {
    return await repo.addFavoriteProduct(productId);
  }
}

class RemoveFavoriteProductUseCase {
  final FavoritesRepo repo;

  RemoveFavoriteProductUseCase(this.repo);

  Future<Either<Failure, void>> call(String productId) async {
    return await repo.removeFavoriteProduct(productId);
  }
}
