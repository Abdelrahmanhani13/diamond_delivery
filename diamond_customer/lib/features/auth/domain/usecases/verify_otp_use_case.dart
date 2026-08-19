import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/auth_tokens.dart';
import 'package:diamond_customer/features/auth/domain/repos/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository _repository;

  VerifyOtpUseCase(this._repository);

  Future<Either<Failure, AuthTokens>> call(
    String phoneNumber,
    String code,
    String otpType,
    String deviceName,
  ) {
    return _repository.verifyOtp(phoneNumber, code, otpType, deviceName);
  }
}
