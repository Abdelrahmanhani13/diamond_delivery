// domain/repositories/vendor_profile_repository.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/vendor_profile.dart';
import '../data/models/vendor_profile_model.dart';
import '../data/models/vendor_update_profile_request_model.dart';
import '../data/models/vendor_register_request_model.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';

abstract class VendorProfileRepository {
  Future<Either<Failure, VendorProfile>> getProfile();

  /// الـ PUT endpoint بياخد الـ body كامل، فالـ caller (الـ Cubit) هو
  /// المسؤول عن دمج القيم الجديدة مع القديمة قبل ما ينادي الدالة دي.
  Future<Either<Failure, VendorProfile>> updateProfile(
    VendorUpdateProfileRequestModel request,
  );

  Future<Either<Failure, void>> registerVendor(VendorRegisterRequestModel request);

  Future<Either<Failure, String>> uploadLogo(File file);

  Future<Either<Failure, String>> uploadCover(File file);
}
