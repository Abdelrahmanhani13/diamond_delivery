import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../repositories/vendor_auth_repository.dart';

class VendorLogoutUseCase {
  final VendorAuthRepository repository;

  VendorLogoutUseCase(this.repository);

  Future<Either<Failure, void>> call(String refreshToken) {
    return repository.logout(refreshToken);
  }
}
