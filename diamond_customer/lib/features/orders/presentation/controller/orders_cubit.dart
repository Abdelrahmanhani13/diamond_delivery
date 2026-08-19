import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/orders_use_cases.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetOrdersUseCase getOrdersUseCase;

  static const int _pageSize = 10;

  OrdersCubit({required this.getOrdersUseCase}) : super(OrdersInitial());

  Future<void> fetchOrders({bool refresh = false}) async {
    if (refresh || state is! OrdersLoaded) {
      emit(OrdersLoading());
    }

    final result = await getOrdersUseCase(page: 1, pageSize: _pageSize);

    result.fold(
      (failure) => emit(OrdersError(message: failure.message)),
      (pageData) => emit(
        OrdersLoaded(
          orders: pageData.items,
          hasNextPage: pageData.hasNextPage,
          currentPage: 1,
        ),
      ),
    );
  }

  Future<void> loadNextPage() async {
    final currentState = state;
    if (currentState is! OrdersLoaded ||
        !currentState.hasNextPage ||
        currentState.isLoadingMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;
    final result = await getOrdersUseCase(page: nextPage, pageSize: _pageSize);

    result.fold(
      (failure) => emit(currentState.copyWith(isLoadingMore: false, message: failure.message)),
      (pageData) => emit(
        OrdersLoaded(
          orders: [...currentState.orders, ...pageData.items],
          hasNextPage: pageData.hasNextPage,
          currentPage: nextPage,
          isLoadingMore: false,
        ),
      ),
    );
  }
}
