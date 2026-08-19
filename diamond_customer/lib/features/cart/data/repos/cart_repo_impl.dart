import 'package:diamond_customer/core/errors/exceptions.dart';
import 'package:diamond_customer/core/errors/failures.dart';
import 'package:diamond_customer/core/network/network_info.dart';
import 'package:diamond_customer/core/utils/either.dart';
import '../../domain/repos/cart_repo.dart';
import '../datasource/cart_remote_data_source.dart';
import '../models/cart_model.dart';
import '../models/cart_requests.dart';

class CartRepoImpl implements CartRepo {
  final CartRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CartRepoImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CartModel>> getCart() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getCart();
        return Right(result);
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
  Future<Either<Failure, CartModel>> addItem(AddToCartRequest request) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.addItem(request);
        return Right(result);
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
  Future<Either<Failure, CartModel>> updateItemQuantity(
    String productId,
    UpdateCartItemRequest request,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updateItemQuantity(productId, request);
        return Right(result);
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
  Future<Either<Failure, CartModel>> removeItem(String productId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.removeItem(productId);
        return Right(result);
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
  Future<Either<Failure, CartModel>> clearCart() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.clearCart();
        return Right(result);
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
