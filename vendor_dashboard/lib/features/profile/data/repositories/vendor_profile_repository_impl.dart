// data/repositories/vendor_profile_repository_impl.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/vendor_profile.dart';
import '../../domain/repositories/vendor_profile_repository.dart';
import '../datasources/vendor_profile_remote_data_source.dart';
import '../models/vendor_update_profile_request_model.dart';
import '../models/vendor_register_request_model.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import 'package:vendor_dashboard/core/errors/exceptions.dart';

class VendorProfileRepositoryImpl implements VendorProfileRepository {
  final VendorProfileRemoteDataSource remoteDataSource;

  VendorProfileRepositoryImpl(this.remoteDataSource);

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
  Future<Either<Failure, void>> registerVendor(VendorRegisterRequestModel request) async {
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
}
