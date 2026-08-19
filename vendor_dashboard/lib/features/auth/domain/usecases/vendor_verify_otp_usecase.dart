
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/auth_tokens.dart';
import 'package:vendor_dashboard/features/auth/domain/entities/auth_tokens.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import 'package:vendor_dashboard/features/auth/domain/repositories/vendor_auth_repository.dart';
import 'package:vendor_dashboard/features/auth/domain/usecases/vendor_verify_otp_usecase.dart';

class VendorVerifyOtpUseCase {
  final VendorAuthRepository _repository;

  VendorVerifyOtpUseCase(this._repository);

  Future<Either<Failure, AuthTokens>> call(
    String phoneNumber,
    String code,
    String otpType,
    String deviceName,
  ) {
    return _repository.verifyOtp(phoneNumber, code, otpType, deviceName);
  }
}
