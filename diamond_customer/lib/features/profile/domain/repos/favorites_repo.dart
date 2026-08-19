import '../../../../core/utils/either.dart';
import '../../../../core/errors/failures.dart';
import '../../../stores/domain/entities/vendor.dart';
import '../../../products/domain/entities/product.dart';

abstract class FavoritesRepo {
  Future<Either<Failure, List<Vendor>>> getFavoriteVendors({
    required int page,
    required int pageSize,
  });

  Future<Either<Failure, List<Product>>> getFavoriteProducts({
    required int page,
    required int pageSize,
  });

  Future<Either<Failure, void>> addFavoriteVendor(String vendorId);

  Future<Either<Failure, void>> removeFavoriteVendor(String vendorId);

  Future<Either<Failure, void>> addFavoriteProduct(String productId);

  Future<Either<Failure, void>> removeFavoriteProduct(String productId);
}
