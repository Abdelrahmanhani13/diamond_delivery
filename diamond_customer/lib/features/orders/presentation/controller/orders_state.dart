import 'package:equatable/equatable.dart';
import '../../data/models/order_model.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<OrderModel> orders;
  final bool hasNextPage;
  final int currentPage;
  final bool isLoadingMore;
  final String? message;

  const OrdersLoaded({
    required this.orders,
    required this.hasNextPage,
    required this.currentPage,
    this.isLoadingMore = false,
    this.message,
  });

  OrdersLoaded copyWith({
    List<OrderModel>? orders,
    bool? hasNextPage,
    int? currentPage,
    bool? isLoadingMore,
    String? message,
  }) {
    return OrdersLoaded(
      orders: orders ?? this.orders,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      message: message,
    );
  }

  @override
  List<Object?> get props => [orders, hasNextPage, currentPage, isLoadingMore, message];
}

class OrdersError extends OrdersState {
  final String message;

  const OrdersError({required this.message});

  @override
  List<Object?> get props => [message];
}
