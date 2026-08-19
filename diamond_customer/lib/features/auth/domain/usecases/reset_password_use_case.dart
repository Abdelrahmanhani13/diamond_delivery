import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import 'package:diamond_customer/features/auth/domain/repos/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<Either<Failure, void>> call(
    String phoneNumber,
    String code,
    String newPassword,
  ) {
    return _repository.resetPassword(phoneNumber, code, newPassword);
  }
}
