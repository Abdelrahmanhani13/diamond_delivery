import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../repositories/vendor_profile_repository.dart';

class VendorUploadLogoUseCase {
  final VendorProfileRepository repository;

  VendorUploadLogoUseCase(this.repository);

  Future<Either<Failure, String>> call(File file) {
    return repository.uploadLogo(file);
  }
}
