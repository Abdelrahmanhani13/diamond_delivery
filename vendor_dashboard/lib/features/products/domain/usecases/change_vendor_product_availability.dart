// domain/usecases/change_vendor_product_availability_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/vendor_product.dart';
import '../repositories/vendor_product_repository.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';

class ChangeVendorProductAvailabilityUseCase {
  final VendorProductRepository repository;
  ChangeVendorProductAvailabilityUseCase(this.repository);

  Future<Either<Failure, VendorProduct>> call({
    required String id,
    required bool isAvailable,
  }) {
    return repository.changeAvailability(id: id, isAvailable: isAvailable);
  }
}
