import 'package:diamond_customer/core/api/api_client.dart';
import 'package:diamond_customer/core/api/api_constants.dart';
import '../models/order_model.dart';
import '../models/order_requests.dart';
import '../models/orders_page_model.dart';

abstract class OrdersRemoteDataSource {
  Future<OrderModel> createOrder(CreateOrderRequest request);
  Future<OrdersPageModel> getOrders({required int page, required int pageSize});
  Future<OrderModel> getOrderById(String id);
  Future<OrderModel> cancelOrder(String id, CancelOrderRequest request);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final ApiClient apiClient;

  OrdersRemoteDataSourceImpl(this.apiClient);

  @override
  Future<OrderModel> createOrder(CreateOrderRequest request) async {
    final response = await apiClient.post(
      ApiConstants.orders,
      data: request.toJson(),
    );
    final data = response['data'] as Map<String, dynamic>;
    return OrderModel.fromJson(data);
  }

  @override
  Future<OrdersPageModel> getOrders({
    required int page,
    required int pageSize,
  }) async {
    final response = await apiClient.get(
      ApiConstants.orders,
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
      },
    );
    final data = response['data'] as Map<String, dynamic>;
    return OrdersPageModel.fromJson(data);
  }

  @override
  Future<OrderModel> getOrderById(String id) async {
    final response = await apiClient.get(ApiConstants.orderById(id));
    final data = response['data'] as Map<String, dynamic>;
    return OrderModel.fromJson(data);
  }

  @override
  Future<OrderModel> cancelOrder(String id, CancelOrderRequest request) async {
    final response = await apiClient.post(
      ApiConstants.cancelOrder(id),
      data: request.toJson(),
    );
    final data = response['data'] as Map<String, dynamic>;
    return OrderModel.fromJson(data);
  }
}
