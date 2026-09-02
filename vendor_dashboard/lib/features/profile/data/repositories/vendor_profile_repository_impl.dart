import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/exceptions.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../../domain/entities/vendor_profile.dart';
import '../../domain/entities/vendor_category.dart';
import '../../domain/repositories/vendor_profile_repository.dart';
import '../datasources/vendor_profile_remote_data_source.dart';
import '../datasources/vendor_categories_remote_data_source.dart';
import '../models/vendor_update_profile_request_model.dart';
import '../models/vendor_register_request_model.dart';
import '../models/vendor_dashboard_stats_model.dart';

class VendorProfileRepositoryImpl implements VendorProfileRepository {
  final VendorProfileRemoteDataSource remoteDataSource;
  final VendorCategoriesRemoteDataSource categoriesRemoteDataSource;

  VendorProfileRepositoryImpl(
    this.remoteDataSource,
    this.categoriesRemoteDataSource,
  );

  @override
  Future<Either<Failure, VendorProfile>> getProfile() async {
    try {
      final profile = await remoteDataSource.getProfile();
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VendorProfile>> updateProfile(
    VendorUpdateProfileRequestModel request,
  ) async {
    try {
      final profile = await remoteDataSource.updateProfile(request);
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerVendor(
    VendorRegisterRequestModel request,
  ) async {
    try {
      await remoteDataSource.registerVendor(request);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadLogo(File file) async {
    try {
      final url = await remoteDataSource.uploadLogo(file);
      return Right(url);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadCover(File file) async {
    try {
      final url = await remoteDataSource.uploadCover(file);
      return Right(url);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VendorProfile>> toggleOpenStatus(
    bool isOpenNow,
  ) async {
    try {
      final profile = await remoteDataSource.toggleOpenStatus(isOpenNow);
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VendorDashboardStatsModel>> getDashboardStats() async {
    try {
      final stats = await remoteDataSource.getDashboardStats();
      return Right(stats);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VendorCategory>>> getVendorCategories() async {
    try {
      final categories = await categoriesRemoteDataSource.getVendorCategories();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
