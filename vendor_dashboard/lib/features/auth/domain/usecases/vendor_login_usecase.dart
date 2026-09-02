import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../entities/auth_tokens.dart';
import '../repositories/vendor_auth_repository.dart';

class VendorLoginUseCase {
  final VendorAuthRepository repository;

  VendorLoginUseCase(this.repository);

  Future<Either<Failure, AuthTokens>> call(
    String phoneNumber,
    String password,
    String deviceName,
  ) {
    return repository.login(phoneNumber, password, deviceName);
  }
}
