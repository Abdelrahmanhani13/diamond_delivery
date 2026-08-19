import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/register_response.dart';
import 'package:diamond_customer/features/auth/domain/repos/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<Either<Failure, RegisterResponse>> call(
    String firstName,
    String lastName,
    String phoneNumber,
    String email,
    String password,
    String roleName,
    String? genderId,
    String? dateOfBirth,
  ) {
    return _repository.register(
      firstName,
      lastName,
      phoneNumber,
      email,
      password,
      roleName,
      genderId,
      dateOfBirth,
    );
  }
}
