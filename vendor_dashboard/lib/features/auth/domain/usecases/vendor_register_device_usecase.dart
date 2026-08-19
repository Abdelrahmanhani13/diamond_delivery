
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import 'package:vendor_dashboard/features/auth/domain/usecases/vendor_register_device_usecase.dart';
import 'package:vendor_dashboard/features/auth/domain/repositories/vendor_auth_repository.dart';

class VendorRegisterDeviceUseCase {
  final VendorAuthRepository _repository;

  VendorRegisterDeviceUseCase(this._repository);

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
