import 'package:equatable/equatable.dart';
import '../../domain/entities/vendor_order.dart';

abstract class VendorOrdersState extends Equatable {
  const VendorOrdersState();

  @override
  List<Object?> get props => [];
}

class VendorOrdersInitial extends VendorOrdersState {
  const VendorOrdersInitial();
}

class VendorOrdersLoading extends VendorOrdersState {
  const VendorOrdersLoading();
}

class VendorOrdersLoaded extends VendorOrdersState {
  final List<VendorOrder> orders;
  final int page;
  final bool hasNextPage;
  final String? selectedStatus;
  final String? actionOrderId;
  final bool isActionLoading;
  final String? actionError;
  final String? actionSuccessMessage;

  const VendorOrdersLoaded({
    required this.orders,
    required this.page,
    required this.hasNextPage,
    this.selectedStatus,
    this.actionOrderId,
    this.isActionLoading = false,
    this.actionError,
    this.actionSuccessMessage,
  });

  VendorOrdersLoaded copyWith({
    List<VendorOrder>? orders,
    int? page,
    bool? hasNextPage,
    String? selectedStatus,
    String? actionOrderId,
    bool? isActionLoading,
    String? actionError,
    String? actionSuccessMessage,
  }) {
    return VendorOrdersLoaded(
      orders: orders ?? this.orders,
      page: page ?? this.page,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      actionOrderId: actionOrderId,
      isActionLoading: isActionLoading ?? false,
      actionError: actionError,
      actionSuccessMessage: actionSuccessMessage,
    );
  }

  @override
  List<Object?> get props => [
    orders,
    page,
    hasNextPage,
    selectedStatus,
    actionOrderId,
    isActionLoading,
    actionError,
    actionSuccessMessage,
  ];
}

class VendorOrdersError extends VendorOrdersState {
  final String message;
  const VendorOrdersError(this.message);

  @override
  List<Object?> get props => [message];
}
