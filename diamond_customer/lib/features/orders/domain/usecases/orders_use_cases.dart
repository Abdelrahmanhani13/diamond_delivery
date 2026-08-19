import 'package:diamond_customer/core/errors/failures.dart';
import 'package:diamond_customer/core/utils/either.dart';
import '../../data/models/order_model.dart';
import '../../data/models/order_requests.dart';
import '../../data/models/orders_page_model.dart';
import '../repos/orders_repo.dart';

class CreateOrderUseCase {
  final OrdersRepo repo;
  CreateOrderUseCase(this.repo);

  Future<Either<Failure, OrderModel>> call(CreateOrderRequest request) =>
      repo.createOrder(request);
}

class GetOrdersUseCase {
  final OrdersRepo repo;
  GetOrdersUseCase(this.repo);

  Future<Either<Failure, OrdersPageModel>> call({
    required int page,
    required int pageSize,
  }) =>
      repo.getOrders(page: page, pageSize: pageSize);
}

class GetOrderByIdUseCase {
  final OrdersRepo repo;
  GetOrderByIdUseCase(this.repo);

  Future<Either<Failure, OrderModel>> call(String id) => repo.getOrderById(id);
}

class CancelOrderUseCase {
  final OrdersRepo repo;
  CancelOrderUseCase(this.repo);

  Future<Either<Failure, OrderModel>> call(
    String id,
    CancelOrderRequest request,
  ) =>
      repo.cancelOrder(id, request);
}
