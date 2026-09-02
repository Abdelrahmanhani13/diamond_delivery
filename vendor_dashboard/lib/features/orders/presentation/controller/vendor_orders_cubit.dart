import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/vendor_order.dart';
import '../../domain/usecases/get_vendor_orders_use_case.dart';
import '../../domain/usecases/get_vendor_order_details_use_case.dart';
import '../../domain/usecases/accept_vendor_order_use_case.dart';
import '../../domain/usecases/reject_vendor_order_use_case.dart';
import '../../domain/usecases/preparing_vendor_order_use_case.dart';
import '../../domain/usecases/ready_vendor_order_use_case.dart';
import 'vendor_orders_state.dart';

class VendorOrdersCubit extends Cubit<VendorOrdersState> {
  final GetVendorOrdersUseCase getOrdersUseCase;
  final GetVendorOrderDetailsUseCase getOrderDetailsUseCase;
  final AcceptVendorOrderUseCase acceptOrderUseCase;
  final RejectVendorOrderUseCase rejectOrderUseCase;
  final PreparingVendorOrderUseCase preparingOrderUseCase;
  final ReadyVendorOrderUseCase readyOrderUseCase;

  VendorOrdersCubit({
    required this.getOrdersUseCase,
    required this.getOrderDetailsUseCase,
    required this.acceptOrderUseCase,
    required this.rejectOrderUseCase,
    required this.preparingOrderUseCase,
    required this.readyOrderUseCase,
  }) : super(const VendorOrdersInitial());

  String? _currentStatus;
  int _currentPage = 1;
  static const int _pageSize = 10;
  bool _isFetchingMore = false;

  Future<void> fetchOrders({String? status, bool isRefresh = false}) async {
    _currentStatus = status;
    if (!isRefresh) {
      emit(const VendorOrdersLoading());
    }
    _currentPage = 1;

    final result = await getOrdersUseCase(
      page: _currentPage,
      pageSize: _pageSize,
      status: _currentStatus,
    );

    result.fold((failure) => emit(VendorOrdersError(failure.errMessage)), (
      paginated,
    ) {
      emit(
        VendorOrdersLoaded(
          orders: paginated.items,
          page: paginated.pageNumber,
          hasNextPage: paginated.hasNextPage,
          selectedStatus: _currentStatus,
        ),
      );
    });
  }

  Future<void> loadMoreOrders() async {
    final currentState = state;
    if (currentState is! VendorOrdersLoaded ||
        !currentState.hasNextPage ||
        _isFetchingMore) {
      return;
    }

    _isFetchingMore = true;
    final nextPage = _currentPage + 1;

    final result = await getOrdersUseCase(
      page: nextPage,
      pageSize: _pageSize,
      status: _currentStatus,
    );

    result.fold(
      (failure) {
        _isFetchingMore = false;
      },
      (paginated) {
        _currentPage = nextPage;
        _isFetchingMore = false;
        final updatedList = List<VendorOrder>.from(currentState.orders)
          ..addAll(paginated.items);

        emit(
          currentState.copyWith(
            orders: updatedList,
            page: paginated.pageNumber,
            hasNextPage: paginated.hasNextPage,
          ),
        );
      },
    );
  }

  Future<void> acceptOrder(String orderId) async {
    await _performOrderAction(
      orderId: orderId,
      actionCall: () => acceptOrderUseCase(orderId),
      successMsg: 'تم قبول الطلب بنجاح',
    );
  }

  Future<void> rejectOrder(String orderId, String reason) async {
    if (reason.trim().isEmpty) return;
    await _performOrderAction(
      orderId: orderId,
      actionCall: () => rejectOrderUseCase(id: orderId, reason: reason),
      successMsg: 'تم رفض الطلب',
    );
  }

  Future<void> preparingOrder(String orderId) async {
    await _performOrderAction(
      orderId: orderId,
      actionCall: () => preparingOrderUseCase(orderId),
      successMsg: 'جارٍ تجهيز الطلب الآن',
    );
  }

  Future<void> readyOrder(String orderId) async {
    await _performOrderAction(
      orderId: orderId,
      actionCall: () => readyOrderUseCase(orderId),
      successMsg: 'الطلب جاهز للتسليم',
    );
  }

  Future<void> _performOrderAction({
    required String orderId,
    required Future<dynamic> Function() actionCall,
    required String successMsg,
  }) async {
    final currentState = state;
    if (currentState is! VendorOrdersLoaded || currentState.isActionLoading) {
      return;
    }

    emit(
      currentState.copyWith(
        actionOrderId: orderId,
        isActionLoading: true,
        actionError: null,
        actionSuccessMessage: null,
      ),
    );

    final result = await actionCall();

    result.fold(
      (failure) {
        emit(
          currentState.copyWith(
            actionOrderId: null,
            isActionLoading: false,
            actionError: failure.errMessage,
          ),
        );
      },
      (updatedOrder) {
        final updatedOrders = currentState.orders.map((order) {
          if (order.id == orderId && updatedOrder is VendorOrder) {
            return updatedOrder;
          }
          return order;
        }).toList();

        emit(
          currentState.copyWith(
            orders: updatedOrders,
            actionOrderId: null,
            isActionLoading: false,
            actionSuccessMessage: successMsg,
          ),
        );
      },
    );
  }
}
