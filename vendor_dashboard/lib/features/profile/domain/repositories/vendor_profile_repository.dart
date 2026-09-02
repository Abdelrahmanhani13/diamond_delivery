import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../entities/vendor_profile.dart';
import '../entities/vendor_category.dart';
import '../../data/models/vendor_update_profile_request_model.dart';
import '../../data/models/vendor_register_request_model.dart';
import '../../data/models/vendor_dashboard_stats_model.dart';

abstract class VendorProfileRepository {
  Future<Either<Failure, VendorProfile>> getProfile();

  Future<Either<Failure, VendorProfile>> updateProfile(
    VendorUpdateProfileRequestModel request,
  );

  Future<Either<Failure, void>> registerVendor(
    VendorRegisterRequestModel request,
  );

  Future<Either<Failure, String>> uploadLogo(File file);

  Future<Either<Failure, String>> uploadCover(File file);

  Future<Either<Failure, VendorProfile>> toggleOpenStatus(bool isOpenNow);

  Future<Either<Failure, VendorDashboardStatsModel>> getDashboardStats();

  Future<Either<Failure, List<VendorCategory>>> getVendorCategories();
}
