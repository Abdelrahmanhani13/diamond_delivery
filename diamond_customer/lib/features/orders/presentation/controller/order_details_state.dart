import 'package:equatable/equatable.dart';
import '../../data/models/order_model.dart';

abstract class OrderDetailsState extends Equatable {
  const OrderDetailsState();

  @override
  List<Object?> get props => [];
}

class OrderDetailsInitial extends OrderDetailsState {}

class OrderDetailsLoading extends OrderDetailsState {}

class OrderDetailsLoaded extends OrderDetailsState {
  final OrderModel order;
  final String? message;

  const OrderDetailsLoaded({required this.order, this.message});

  @override
  List<Object?> get props => [order, message];
}

class OrderDetailsError extends OrderDetailsState {
  final String message;

  const OrderDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class OrderCancelling extends OrderDetailsState {}
