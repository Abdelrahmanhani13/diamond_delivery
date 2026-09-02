import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../repositories/vendor_auth_repository.dart';

class VendorRegisterDeviceUseCase {
  final VendorAuthRepository repository;

  VendorRegisterDeviceUseCase(this.repository);

  Future<Either<Failure, void>> call(
    String devicePlatform,
    String deviceId,
    String firebaseToken,
    String appVersion,
  ) {
    return repository.registerDevice(
      devicePlatform,
      deviceId,
      firebaseToken,
      appVersion,
    );
  }
}
