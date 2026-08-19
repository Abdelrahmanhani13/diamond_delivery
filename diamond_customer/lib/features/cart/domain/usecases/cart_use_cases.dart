import 'package:diamond_customer/core/errors/failures.dart';
import 'package:diamond_customer/core/utils/either.dart';
import '../../data/models/cart_model.dart';
import '../../data/models/cart_requests.dart';
import '../repos/cart_repo.dart';

class GetCartUseCase {
  final CartRepo repo;
  GetCartUseCase(this.repo);

  Future<Either<Failure, CartModel>> call() => repo.getCart();
}

class AddToCartUseCase {
  final CartRepo repo;
  AddToCartUseCase(this.repo);

  Future<Either<Failure, CartModel>> call(AddToCartRequest request) =>
      repo.addItem(request);
}

class UpdateCartItemUseCase {
  final CartRepo repo;
  UpdateCartItemUseCase(this.repo);

  Future<Either<Failure, CartModel>> call(
    String productId,
    UpdateCartItemRequest request,
  ) =>
      repo.updateItemQuantity(productId, request);
}

class RemoveCartItemUseCase {
  final CartRepo repo;
  RemoveCartItemUseCase(this.repo);

  Future<Either<Failure, CartModel>> call(String productId) =>
      repo.removeItem(productId);
}

class ClearCartUseCase {
  final CartRepo repo;
  ClearCartUseCase(this.repo);

  Future<Either<Failure, CartModel>> call() => repo.clearCart();
}
