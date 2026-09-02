import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../entities/vendor_profile.dart';
import '../repositories/vendor_profile_repository.dart';

class VendorGetProfileUseCase {
  final VendorProfileRepository repository;

  VendorGetProfileUseCase(this.repository);

  Future<Either<Failure, VendorProfile>> call() {
    return repository.getProfile();
  }
}
