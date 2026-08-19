import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/request_otp_response.dart';
import 'package:diamond_customer/features/auth/domain/repos/auth_repository.dart';

class RequestOtpUseCase {
  final AuthRepository _repository;

  RequestOtpUseCase(this._repository);

  Future<Either<Failure, RequestOtpResponse>> call(
    String phoneNumber,
    String otpType,
  ) {
    return _repository.requestOtp(phoneNumber, otpType);
  }
}
