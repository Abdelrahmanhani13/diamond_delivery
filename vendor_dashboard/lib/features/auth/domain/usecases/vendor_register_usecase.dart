
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/register_response.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import 'package:vendor_dashboard/features/auth/domain/repositories/vendor_auth_repository.dart';

class VendorRegisterUseCase {
  final VendorAuthRepository _repository;

  VendorRegisterUseCase(this._repository);

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
