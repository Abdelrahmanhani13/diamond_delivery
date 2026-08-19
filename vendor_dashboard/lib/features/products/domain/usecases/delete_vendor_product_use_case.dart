// domain/usecases/delete_vendor_product_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/vendor_product_repository.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';

class DeleteVendorProductUseCase {
  final VendorProductRepository repository;
  DeleteVendorProductUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteProduct(id);
  }
}
