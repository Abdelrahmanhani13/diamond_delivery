import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/vendor.dart';
import '../../domain/repos/stores_repo.dart';
import '../datasource/stores_remote_data_source.dart';
import 'package:diamond_customer/core/errors/exceptions.dart';
import 'package:diamond_customer/core/network/network_info.dart';

class StoresRepoImpl implements StoresRepo {
  final StoresRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  StoresRepoImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<Vendor>>> getVendors({
    required int page,
    required int pageSize,
    String? search,
    String? categoryId,
    bool? openNow,
    double? rating,
    String? sortBy,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final vendors = await remoteDataSource.getVendors(
          page: page,
          pageSize: pageSize,
          search: search,
          categoryId: categoryId,
          openNow: openNow,
          rating: rating,
          sortBy: sortBy,
        );
        return Right(vendors);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, errors: e.errors));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, List<Vendor>>> getNearbyVendors({
    required double latitude,
    required double longitude,
    required double radiusKm,
    required int page,
    required int pageSize,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final vendors = await remoteDataSource.getNearbyVendors(
          latitude: latitude,
          longitude: longitude,
          radiusKm: radiusKm,
          page: page,
          pageSize: pageSize,
        );
        return Right(vendors);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, errors: e.errors));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, Vendor>> getVendorById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final vendor = await remoteDataSource.getVendorById(id);
        return Right(vendor);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, errors: e.errors));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }
}
