import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../products/domain/entities/product.dart';
import '../../../stores/domain/entities/vendor.dart';
import '../../domain/repos/favorites_repo.dart';
import '../datasource/favorites_remote_data_source.dart';
import 'package:diamond_customer/core/errors/exceptions.dart';
import 'package:diamond_customer/core/network/network_info.dart';

class FavoritesRepoImpl implements FavoritesRepo {
  final FavoritesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FavoritesRepoImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Vendor>>> getFavoriteVendors({
    required int page,
    required int pageSize,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final vendors = await remoteDataSource.getFavoriteVendors(
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
  Future<Either<Failure, List<Product>>> getFavoriteProducts({
    required int page,
    required int pageSize,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getFavoriteProducts(
          page: page,
          pageSize: pageSize,
        );
        return Right(products);
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
  Future<Either<Failure, void>> addFavoriteVendor(String vendorId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addFavoriteVendor(vendorId);
        return const Right(null);
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
  Future<Either<Failure, void>> removeFavoriteVendor(String vendorId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.removeFavoriteVendor(vendorId);
        return const Right(null);
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
  Future<Either<Failure, void>> addFavoriteProduct(String productId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addFavoriteProduct(productId);
        return const Right(null);
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
  Future<Either<Failure, void>> removeFavoriteProduct(String productId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.removeFavoriteProduct(productId);
        return const Right(null);
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
