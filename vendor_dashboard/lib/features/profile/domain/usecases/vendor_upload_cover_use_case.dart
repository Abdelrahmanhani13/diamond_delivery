// domain/usecases/vendor_upload_cover_usecase.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/vendor_profile_repository.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';

class VendorUploadCoverUseCase {
  final VendorProfileRepository repository;

  VendorUploadCoverUseCase(this.repository);

  Future<Either<Failure, String>> call(File file) {
    return repository.uploadCover(file);
  }
}
