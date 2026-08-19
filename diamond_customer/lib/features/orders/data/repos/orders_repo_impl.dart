import 'package:diamond_customer/core/errors/exceptions.dart';
import 'package:diamond_customer/core/errors/failures.dart';
import 'package:diamond_customer/core/network/network_info.dart';
import 'package:diamond_customer/core/utils/either.dart';
import '../../domain/repos/orders_repo.dart';
import '../datasource/orders_remote_data_source.dart';
import '../models/order_model.dart';
import '../models/order_requests.dart';
import '../models/orders_page_model.dart';

class OrdersRepoImpl implements OrdersRepo {
  final OrdersRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OrdersRepoImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, OrderModel>> createOrder(
    CreateOrderRequest request,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.createOrder(request);
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
  Future<Either<Failure, OrdersPageModel>> getOrders({
    required int page,
    required int pageSize,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getOrders(
          page: page,
          pageSize: pageSize,
        );
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
  Future<Either<Failure, OrderModel>> getOrderById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getOrderById(id);
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
  Future<Either<Failure, OrderModel>> cancelOrder(
    String id,
    CancelOrderRequest request,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.cancelOrder(id, request);
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
