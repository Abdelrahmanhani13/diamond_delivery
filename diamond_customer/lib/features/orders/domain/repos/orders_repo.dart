import 'package:diamond_customer/core/errors/failures.dart';
import 'package:diamond_customer/core/utils/either.dart';
import '../../data/models/order_model.dart';
import '../../data/models/order_requests.dart';
import '../../data/models/orders_page_model.dart';

abstract class OrdersRepo {
  Future<Either<Failure, OrderModel>> createOrder(CreateOrderRequest request);
  Future<Either<Failure, OrdersPageModel>> getOrders({
    required int page,
    required int pageSize,
  });
  Future<Either<Failure, OrderModel>> getOrderById(String id);
  Future<Either<Failure, OrderModel>> cancelOrder(
    String id,
    CancelOrderRequest request,
  );
}
