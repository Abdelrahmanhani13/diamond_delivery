import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../entities/request_otp_response.dart';
import '../repositories/vendor_auth_repository.dart';

class VendorRequestOtpUseCase {
  final VendorAuthRepository repository;

  VendorRequestOtpUseCase(this.repository);

  Future<Either<Failure, RequestOtpResponse>> call(
    String phoneNumber,
    String otpType,
  ) {
    return repository.requestOtp(phoneNumber, otpType);
  }
}
