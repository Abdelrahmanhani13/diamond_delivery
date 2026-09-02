import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../repositories/vendor_product_repository.dart';

class DeleteVendorProductImageUseCase {
  final VendorProductRepository repository;

  DeleteVendorProductImageUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String productId,
    required String imageId,
  }) {
    return repository.deleteImage(productId: productId, imageId: imageId);
  }
}
