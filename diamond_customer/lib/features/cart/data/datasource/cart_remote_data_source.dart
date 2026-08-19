import 'package:diamond_customer/core/api/api_client.dart';
import 'package:diamond_customer/core/api/api_constants.dart';
import '../models/cart_model.dart';
import '../models/cart_requests.dart';

abstract class CartRemoteDataSource {
  Future<CartModel> getCart();
  Future<CartModel> addItem(AddToCartRequest request);
  Future<CartModel> updateItemQuantity(String productId, UpdateCartItemRequest request);
  Future<CartModel> removeItem(String productId);
  Future<CartModel> clearCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiClient apiClient;

  CartRemoteDataSourceImpl(this.apiClient);

  @override
  Future<CartModel> getCart() async {
    final response = await apiClient.get(ApiConstants.cart);
    final data = response['data'] as Map<String, dynamic>;
    return CartModel.fromJson(data);
  }

  @override
  Future<CartModel> addItem(AddToCartRequest request) async {
    final response = await apiClient.post(
      ApiConstants.cartItems,
      data: request.toJson(),
    );
    final data = response['data'] as Map<String, dynamic>;
    return CartModel.fromJson(data);
  }

  @override
  Future<CartModel> updateItemQuantity(
    String productId,
    UpdateCartItemRequest request,
  ) async {
    final response = await apiClient.put(
      ApiConstants.cartItemByProductId(productId),
      data: request.toJson(),
    );
    final data = response['data'] as Map<String, dynamic>;
    return CartModel.fromJson(data);
  }

  @override
  Future<CartModel> removeItem(String productId) async {
    final response = await apiClient.delete(
      ApiConstants.cartItemByProductId(productId),
    );
    final data = response['data'] as Map<String, dynamic>;
    return CartModel.fromJson(data);
  }

  @override
  Future<CartModel> clearCart() async {
    final response = await apiClient.delete(ApiConstants.clearCart);
    final data = response['data'] as Map<String, dynamic>;
    return CartModel.fromJson(data);
  }
}
