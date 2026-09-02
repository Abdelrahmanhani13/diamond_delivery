import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../entities/vendor_product.dart';
import '../repositories/vendor_product_repository.dart';

class GetVendorProductsUseCase {
  final VendorProductRepository repository;

  GetVendorProductsUseCase(this.repository);

  Future<Either<Failure, ({List<VendorProduct> products, bool hasNextPage})>>
  call({
    required int page,
    required int pageSize,
    String? subCategoryId,
    String? search,
    bool? isAvailable,
    int? sortBy,
  }) {
    return repository.getProducts(
      page: page,
      pageSize: pageSize,
      subCategoryId: subCategoryId,
      search: search,
      isAvailable: isAvailable,
      sortBy: sortBy,
    );
  }
}
