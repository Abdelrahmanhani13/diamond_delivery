import '../../../../core/utils/either.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../repos/products_repo.dart';

class GetProductsUseCase {
  final ProductsRepo repo;

  GetProductsUseCase(this.repo);

  Future<Either<Failure, List<Product>>> call({
    required int page,
    required int pageSize,
    String? search,
    String? vendorCategoryId,
    String? subCategoryId,
    String? vendorId,
    double? minPrice,
    double? maxPrice,
    int? sortBy,
  }) async {
    return await repo.getProducts(
      page: page,
      pageSize: pageSize,
      search: search,
      vendorCategoryId: vendorCategoryId,
      subCategoryId: subCategoryId,
      vendorId: vendorId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      sortBy: sortBy,
    );
  }
}

class GetProductByIdUseCase {
  final ProductsRepo repo;

  GetProductByIdUseCase(this.repo);

  Future<Either<Failure, Product>> call(String id) async {
    return await repo.getProductById(id);
  }
}

class GetRelatedProductsUseCase {
  final ProductsRepo repo;

  GetRelatedProductsUseCase(this.repo);

  Future<Either<Failure, List<Product>>> call(String productId) async {
    return await repo.getRelatedProducts(productId);
  }
}
