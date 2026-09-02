import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../entities/vendor_product.dart';
import '../repositories/vendor_product_repository.dart';

class GetVendorProductByIdUseCase {
  final VendorProductRepository repository;

  GetVendorProductByIdUseCase(this.repository);

  Future<Either<Failure, VendorProduct>> call(String id) {
    return repository.getProductById(id);
  }
}
