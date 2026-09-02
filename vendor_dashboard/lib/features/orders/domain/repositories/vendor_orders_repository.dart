import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../entities/vendor_order.dart';
import '../../data/models/paginated_orders_model.dart';

abstract class VendorOrdersRepository {
  Future<Either<Failure, PaginatedOrdersModel>> getOrders({
    required int page,
    required int pageSize,
    String? status,
  });

  Future<Either<Failure, VendorOrder>> getOrderById(String id);

  Future<Either<Failure, VendorOrder>> acceptOrder(String id);

  Future<Either<Failure, VendorOrder>> rejectOrder({
    required String id,
    required String reason,
  });

  Future<Either<Failure, VendorOrder>> preparingOrder(String id);

  Future<Either<Failure, VendorOrder>> readyOrder(String id);
}
