import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import 'package:diamond_customer/features/auth/domain/repos/auth_repository.dart';

class RegisterDeviceUseCase {
  final AuthRepository _repository;

  RegisterDeviceUseCase(this._repository);

  Future<Either<Failure, void>> call(
    String devicePlatform,
    String deviceId,
    String firebaseToken,
    String appVersion,
  ) {
    return _repository.registerDevice(
      devicePlatform,
      deviceId,
      firebaseToken,
      appVersion,
    );
  }
}
