import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import 'package:diamond_customer/features/auth/domain/repos/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<Either<Failure, void>> call(String refreshToken) {
    return _repository.logout(refreshToken);
  }
}
