import 'package:equatable/equatable.dart';
import '../../data/models/checkout_model.dart';
import '../../../orders/data/models/order_model.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutLoaded extends CheckoutState {
  final CheckoutModel checkout;
  final String? selectedAddressId;
  final String? selectedPaymentMethodId;
  final String? message;

  const CheckoutLoaded({
    required this.checkout,
    this.selectedAddressId,
    this.selectedPaymentMethodId,
    this.message,
  });

  @override
  List<Object?> get props => [checkout, selectedAddressId, selectedPaymentMethodId, message];
}

class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CheckoutPlacingOrder extends CheckoutState {}

class CheckoutOrderSuccess extends CheckoutState {
  final OrderModel order;

  const CheckoutOrderSuccess({required this.order});

  @override
  List<Object?> get props => [order];
}
