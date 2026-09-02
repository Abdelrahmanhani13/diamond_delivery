import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../entities/auth_tokens.dart';
import '../repositories/vendor_auth_repository.dart';

class VendorVerifyOtpUseCase {
  final VendorAuthRepository repository;

  VendorVerifyOtpUseCase(this.repository);

  Future<Either<Failure, AuthTokens>> call(
    String phoneNumber,
    String code,
    String otpType,
    String deviceName,
  ) {
    return repository.verifyOtp(phoneNumber, code, otpType, deviceName);
  }
}
