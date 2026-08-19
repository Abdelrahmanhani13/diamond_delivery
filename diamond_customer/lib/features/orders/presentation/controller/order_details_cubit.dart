import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/order_model.dart';
import '../../data/models/order_requests.dart';
import '../../domain/usecases/orders_use_cases.dart';
import 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final GetOrderByIdUseCase getOrderByIdUseCase;
  final CancelOrderUseCase cancelOrderUseCase;

  OrderDetailsCubit({
    required this.getOrderByIdUseCase,
    required this.cancelOrderUseCase,
  }) : super(OrderDetailsInitial());

  Future<void> fetchOrderDetails(String id) async {
    emit(OrderDetailsLoading());
    final result = await getOrderByIdUseCase(id);
    result.fold(
      (failure) => emit(OrderDetailsError(message: failure.message)),
      (order) => emit(OrderDetailsLoaded(order: order)),
    );
  }

  Future<void> cancelOrder(String id, String reason) async {
    final currentState = state;
    OrderModel? currentOrder;
    if (currentState is OrderDetailsLoaded) {
      currentOrder = currentState.order;
    }

    emit(OrderCancelling());

    final result = await cancelOrderUseCase(
      id,
      CancelOrderRequest(reason: reason),
    );

    result.fold(
      (failure) {
        if (currentOrder != null) {
          emit(OrderDetailsLoaded(order: currentOrder, message: failure.message));
        } else {
          emit(OrderDetailsError(message: failure.message));
        }
      },
      (updatedOrder) => emit(
        OrderDetailsLoaded(
          order: updatedOrder,
          message: 'تم إلغاء الطلب بنجاح',
        ),
      ),
    );
  }
}
