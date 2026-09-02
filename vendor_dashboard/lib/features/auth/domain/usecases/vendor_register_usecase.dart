import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../entities/register_response.dart';
import '../repositories/vendor_auth_repository.dart';

class VendorRegisterUseCase {
  final VendorAuthRepository repository;

  VendorRegisterUseCase(this.repository);

  Future<Either<Failure, RegisterResponse>> call({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required String password,
    required String roleName,
    String? genderId,
    String? dateOfBirth,
  }) {
    return repository.register(
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
