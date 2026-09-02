import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../repositories/vendor_product_repository.dart';

class DeleteVendorProductUseCase {
  final VendorProductRepository repository;

  DeleteVendorProductUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteProduct(id);
  }
}
