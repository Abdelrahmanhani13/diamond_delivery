import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/exceptions.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../../domain/entities/vendor_order.dart';
import '../../domain/repositories/vendor_orders_repository.dart';
import '../datasources/vendor_orders_remote_data_source.dart';
import '../models/paginated_orders_model.dart';

class VendorOrdersRepositoryImpl implements VendorOrdersRepository {
  final VendorOrdersRemoteDataSource remoteDataSource;

  VendorOrdersRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PaginatedOrdersModel>> getOrders({
    required int page,
    required int pageSize,
    String? status,
  }) async {
    try {
      final result = await remoteDataSource.getOrders(
        page: page,
        pageSize: pageSize,
        status: status,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VendorOrder>> getOrderById(String id) async {
    try {
      final order = await remoteDataSource.getOrderById(id);
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VendorOrder>> acceptOrder(String id) async {
    try {
      final order = await remoteDataSource.acceptOrder(id);
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VendorOrder>> rejectOrder({
    required String id,
    required String reason,
  }) async {
    try {
      final order = await remoteDataSource.rejectOrder(id: id, reason: reason);
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VendorOrder>> preparingOrder(String id) async {
    try {
      final order = await remoteDataSource.preparingOrder(id);
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VendorOrder>> readyOrder(String id) async {
    try {
      final order = await remoteDataSource.readyOrder(id);
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
