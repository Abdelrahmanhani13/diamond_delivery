import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../../data/models/vendor_update_profile_request_model.dart';
import '../entities/vendor_profile.dart';
import '../repositories/vendor_profile_repository.dart';

class VendorUpdateProfileUseCase {
  final VendorProfileRepository repository;

  VendorUpdateProfileUseCase(this.repository);

  Future<Either<Failure, VendorProfile>> call(
    VendorUpdateProfileRequestModel request,
  ) {
    return repository.updateProfile(request);
  }
}
