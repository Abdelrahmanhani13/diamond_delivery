import '../../../../core/utils/either.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';

abstract class ProductsRepo {
  Future<Either<Failure, List<Product>>> getProducts({
    required int page,
    required int pageSize,
    String? search,
    String? vendorCategoryId,
    String? subCategoryId,
    String? vendorId,
    double? minPrice,
    double? maxPrice,
    int? sortBy, // ProductDiscoverySortBy: 0, 1, 2, 3, 4
  });

  Future<Either<Failure, Product>> getProductById(String id);

  Future<Either<Failure, List<Product>>> getRelatedProducts(String productId);
}
