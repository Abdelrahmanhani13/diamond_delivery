// domain/usecases/delete_vendor_product_image_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/vendor_product_repository.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';

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
