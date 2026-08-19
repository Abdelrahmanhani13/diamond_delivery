
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import 'package:vendor_dashboard/features/auth/domain/repositories/vendor_auth_repository.dart';
import 'package:vendor_dashboard/features/auth/domain/usecases/vendor_reset_password_usecase.dart';

class VendorResetPasswordUseCase {
  final VendorAuthRepository _repository;

  VendorResetPasswordUseCase(this._repository);

  Future<Either<Failure, void>> call(
    String phoneNumber,
    String code,
    String newPassword,
  ) {
    return _repository.resetPassword(phoneNumber, code, newPassword);
  }
}
