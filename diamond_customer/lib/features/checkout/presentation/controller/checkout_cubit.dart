import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/checkout_model.dart';
import '../../domain/usecases/get_checkout_use_case.dart';
import '../../../orders/data/models/order_requests.dart';
import '../../../orders/domain/usecases/orders_use_cases.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final GetCheckoutUseCase getCheckoutUseCase;
  final CreateOrderUseCase createOrderUseCase;

  String? _selectedAddressId;
  String? _selectedPaymentMethodId;

  CheckoutCubit({
    required this.getCheckoutUseCase,
    required this.createOrderUseCase,
  }) : super(CheckoutInitial());

  Future<void> loadCheckout({
    String? addressId,
    String? paymentMethodId,
  }) async {
    if (addressId != null) _selectedAddressId = addressId;
    if (paymentMethodId != null) _selectedPaymentMethodId = paymentMethodId;

    emit(CheckoutLoading());

    final result = await getCheckoutUseCase(
      addressId: _selectedAddressId,
      paymentMethodId: _selectedPaymentMethodId,
    );

    result.fold(
      (failure) => emit(CheckoutError(message: failure.message)),
      (checkout) {
        _selectedAddressId = checkout.selectedAddress?.id ?? _selectedAddressId;
        _selectedPaymentMethodId =
            checkout.selectedPaymentMethodId ?? _selectedPaymentMethodId;

        // If no payment method selected yet, pick first available
        if ((_selectedPaymentMethodId == null || _selectedPaymentMethodId!.isEmpty) &&
            checkout.availablePaymentMethods.isNotEmpty) {
          _selectedPaymentMethodId = checkout.availablePaymentMethods.first.id;
        }

        emit(
          CheckoutLoaded(
            checkout: checkout,
            selectedAddressId: _selectedAddressId,
            selectedPaymentMethodId: _selectedPaymentMethodId,
          ),
        );
      },
    );
  }

  Future<void> selectAddress(String addressId) async {
    _selectedAddressId = addressId;
    await loadCheckout(
      addressId: _selectedAddressId,
      paymentMethodId: _selectedPaymentMethodId,
    );
  }

  Future<void> selectPaymentMethod(String paymentMethodId) async {
    _selectedPaymentMethodId = paymentMethodId;
    await loadCheckout(
      addressId: _selectedAddressId,
      paymentMethodId: _selectedPaymentMethodId,
    );
  }

  Future<void> placeOrder(String? customerNotes) async {
    if (_selectedAddressId == null || _selectedAddressId!.isEmpty) {
      emit(const CheckoutError(message: 'يرجى اختيار عنوان التوصيل'));
      return;
    }
    if (_selectedPaymentMethodId == null || _selectedPaymentMethodId!.isEmpty) {
      emit(const CheckoutError(message: 'يرجى اختيار طريقة الدفع'));
      return;
    }

    final currentState = state;
    CheckoutModel? currentCheckout;
    if (currentState is CheckoutLoaded) {
      currentCheckout = currentState.checkout;
      if (!currentCheckout.isEligibleToCheckout) {
        final issueMsg = currentCheckout.issues.isNotEmpty
            ? currentCheckout.issues.map((e) => e.message).join('\n')
            : 'غير مؤهل لإتمام الطلب حالياً';
        emit(CheckoutLoaded(checkout: currentCheckout, message: issueMsg));
        return;
      }
    }

    emit(CheckoutPlacingOrder());

    final request = CreateOrderRequest(
      addressId: _selectedAddressId!,
      paymentMethodId: _selectedPaymentMethodId!,
      customerNotes: customerNotes,
    );

    final result = await createOrderUseCase(request);

    result.fold(
      (failure) {
        if (currentCheckout != null) {
          emit(CheckoutLoaded(checkout: currentCheckout, message: failure.message));
        } else {
          emit(CheckoutError(message: failure.message));
        }
      },
      (order) => emit(CheckoutOrderSuccess(order: order)),
    );
  }
}
