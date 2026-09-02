import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../repositories/vendor_auth_repository.dart';

class VendorResetPasswordUseCase {
  final VendorAuthRepository repository;

  VendorResetPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call(
    String phoneNumber,
    String code,
    String newPassword,
  ) {
    return repository.resetPassword(phoneNumber, code, newPassword);
  }
}
