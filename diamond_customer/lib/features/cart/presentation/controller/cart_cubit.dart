import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/cart_model.dart';
import '../../data/models/cart_requests.dart';
import '../../domain/usecases/cart_use_cases.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final RemoveCartItemUseCase removeCartItemUseCase;
  final ClearCartUseCase clearCartUseCase;

  CartCubit({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.updateCartItemUseCase,
    required this.removeCartItemUseCase,
    required this.clearCartUseCase,
  }) : super(CartInitial());

  Future<void> fetchCart() async {
    emit(CartLoading());
    final result = await getCartUseCase();
    result.fold(
      (failure) => emit(CartError(message: failure.message)),
      (cart) => emit(CartLoaded(cart: cart)),
    );
  }

  Future<void> addToCart(String productId, int quantity) async {
    final currentState = state;
    if (currentState is! CartLoaded) {
      emit(CartLoading());
    }

    final result = await addToCartUseCase(
      AddToCartRequest(productId: productId, quantity: quantity),
    );

    result.fold(
      (failure) {
        if (currentState is CartLoaded) {
          emit(CartLoaded(cart: currentState.cart, message: failure.message));
        } else {
          emit(CartError(message: failure.message));
        }
      },
      (updatedCart) => emit(CartLoaded(cart: updatedCart)),
    );
  }

  Future<void> updateItemQuantity(String productId, int quantity) async {
    final currentState = state;
    CartModel? previousCart;
    if (currentState is CartLoaded) {
      previousCart = currentState.cart;
    }

    final result = await updateCartItemUseCase(
      productId,
      UpdateCartItemRequest(quantity: quantity),
    );

    result.fold(
      (failure) {
        if (previousCart != null) {
          emit(CartLoaded(cart: previousCart, message: failure.message));
        } else {
          emit(CartError(message: failure.message));
        }
      },
      (updatedCart) => emit(CartLoaded(cart: updatedCart)),
    );
  }

  Future<void> removeItem(String productId) async {
    final currentState = state;
    CartModel? previousCart;
    if (currentState is CartLoaded) {
      previousCart = currentState.cart;
    }

    final result = await removeCartItemUseCase(productId);

    result.fold(
      (failure) {
        if (previousCart != null) {
          emit(CartLoaded(cart: previousCart, message: failure.message));
        } else {
          emit(CartError(message: failure.message));
        }
      },
      (updatedCart) => emit(CartLoaded(cart: updatedCart)),
    );
  }

  Future<void> clearCart() async {
    final currentState = state;
    CartModel? previousCart;
    if (currentState is CartLoaded) {
      previousCart = currentState.cart;
    }

    final result = await clearCartUseCase();

    result.fold(
      (failure) {
        if (previousCart != null) {
          emit(CartLoaded(cart: previousCart, message: failure.message));
        } else {
          emit(CartError(message: failure.message));
        }
      },
      (updatedCart) => emit(CartLoaded(cart: updatedCart)),
    );
  }
}
