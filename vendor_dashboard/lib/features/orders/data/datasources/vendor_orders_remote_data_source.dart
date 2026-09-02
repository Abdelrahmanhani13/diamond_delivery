import 'package:vendor_dashboard/core/api/api_client.dart';
import 'package:vendor_dashboard/core/api/api_constants.dart';
import '../models/vendor_order_model.dart';
import '../models/paginated_orders_model.dart';

abstract class VendorOrdersRemoteDataSource {
  Future<PaginatedOrdersModel> getOrders({
    required int page,
    required int pageSize,
    String? status,
  });

  Future<VendorOrderModel> getOrderById(String id);

  Future<VendorOrderModel> acceptOrder(String id);

  Future<VendorOrderModel> rejectOrder({
    required String id,
    required String reason,
  });

  Future<VendorOrderModel> preparingOrder(String id);

  Future<VendorOrderModel> readyOrder(String id);
}

class VendorOrdersRemoteDataSourceImpl implements VendorOrdersRemoteDataSource {
  final ApiClient apiClient;

  VendorOrdersRemoteDataSourceImpl(this.apiClient);

  @override
  Future<PaginatedOrdersModel> getOrders({
    required int page,
    required int pageSize,
    String? status,
  }) async {
    final query = <String, dynamic>{'page': page, 'pageSize': pageSize};
    if (status != null && status.isNotEmpty) {
      query['status'] = status;
    }

    final response = await apiClient.get(
      ApiConstants.vendorOrders,
      queryParameters: query,
    );
    return PaginatedOrdersModel.fromJson(response);
  }

  @override
  Future<VendorOrderModel> getOrderById(String id) async {
    final response = await apiClient.get(ApiConstants.vendorOrderById(id));
    return VendorOrderModel.fromJson(response);
  }

  @override
  Future<VendorOrderModel> acceptOrder(String id) async {
    final response = await apiClient.patch(ApiConstants.vendorOrderAccept(id));
    return VendorOrderModel.fromJson(response);
  }

  @override
  Future<VendorOrderModel> rejectOrder({
    required String id,
    required String reason,
  }) async {
    final response = await apiClient.patch(
      ApiConstants.vendorOrderReject(id),
      data: {'reason': reason},
    );
    return VendorOrderModel.fromJson(response);
  }

  @override
  Future<VendorOrderModel> preparingOrder(String id) async {
    final response = await apiClient.patch(
      ApiConstants.vendorOrderPreparing(id),
    );
    return VendorOrderModel.fromJson(response);
  }

  @override
  Future<VendorOrderModel> readyOrder(String id) async {
    final response = await apiClient.patch(ApiConstants.vendorOrderReady(id));
    return VendorOrderModel.fromJson(response);
  }
}
