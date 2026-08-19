import 'package:diamond_customer/core/errors/failures.dart';
import 'package:diamond_customer/core/utils/either.dart';
import '../../data/models/cart_model.dart';
import '../../data/models/cart_requests.dart';

abstract class CartRepo {
  Future<Either<Failure, CartModel>> getCart();
  Future<Either<Failure, CartModel>> addItem(AddToCartRequest request);
  Future<Either<Failure, CartModel>> updateItemQuantity(
    String productId,
    UpdateCartItemRequest request,
  );
  Future<Either<Failure, CartModel>> removeItem(String productId);
  Future<Either<Failure, CartModel>> clearCart();
}
