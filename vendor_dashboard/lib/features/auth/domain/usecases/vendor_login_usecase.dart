
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/auth_tokens.dart';
import 'package:vendor_dashboard/features/auth/domain/entities/auth_tokens.dart';
import 'package:vendor_dashboard/features/auth/domain/usecases/vendor_login_usecase.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import 'package:vendor_dashboard/features/auth/domain/repositories/vendor_auth_repository.dart';

class VendorLoginUseCase {
  final VendorAuthRepository _repository;

  VendorLoginUseCase(this._repository);

  Future<Either<Failure, AuthTokens>> call(String phoneNumber, String password, String deviceName) {
    return _repository.login(phoneNumber, password, deviceName);
  }
}
