
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/request_otp_response.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import 'package:vendor_dashboard/features/auth/domain/repositories/vendor_auth_repository.dart';
import 'package:vendor_dashboard/features/auth/domain/usecases/vendor_request_otp_usecase.dart';

class VendorRequestOtpUseCase {
  final VendorAuthRepository _repository;

  VendorRequestOtpUseCase(this._repository);

  Future<Either<Failure, RequestOtpResponse>> call(String phoneNumber, String otpType) {
    return _repository.requestOtp(phoneNumber, otpType);
  }
}
