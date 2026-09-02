import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../entities/vendor_category.dart';
import '../repositories/vendor_profile_repository.dart';

class GetVendorCategoriesUseCase {
  final VendorProfileRepository repository;

  GetVendorCategoriesUseCase(this.repository);

  Future<Either<Failure, List<VendorCategory>>> call() {
    return repository.getVendorCategories();
  }
}
