
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import 'package:vendor_dashboard/features/auth/domain/repositories/vendor_auth_repository.dart';
import 'package:vendor_dashboard/features/auth/domain/usecases/vendor_logout_usecase.dart';

class VendorLogoutUseCase {
  final VendorAuthRepository _repository;

  VendorLogoutUseCase(this._repository);

  Future<Either<Failure, void>> call(String refreshToken) {
    return _repository.logout(refreshToken);
  }
}
