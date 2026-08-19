import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/auth_tokens.dart';
import 'package:diamond_customer/features/auth/domain/repos/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<Failure, AuthTokens>> call(
    String phoneNumber,
    String password,
    String deviceName,
  ) {
    return _repository.login(phoneNumber, password, deviceName);
  }
}
