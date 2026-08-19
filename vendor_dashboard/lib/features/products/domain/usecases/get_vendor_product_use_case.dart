// domain/usecases/get_vendor_products_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/vendor_product.dart';
import '../repositories/vendor_product_repository.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';

class GetVendorProductsUseCase {
  final VendorProductRepository repository;
  GetVendorProductsUseCase(this.repository);

  Future<Either<Failure, ({List<VendorProduct> products, bool hasNextPage})>>
  call({required int page, required int pageSize, String? subCategoryId}) {
    return repository.getProducts(
      page: page,
      pageSize: pageSize,
      subCategoryId: subCategoryId,
    );
  }
}
