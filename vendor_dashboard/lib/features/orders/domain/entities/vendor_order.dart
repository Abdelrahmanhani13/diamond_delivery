import 'package:equatable/equatable.dart';
import 'vendor_order_item.dart';
import 'vendor_address.dart';

class VendorOrder extends Equatable {
  final String id;
  final String orderNumber;
  final String customerName;
  final String customerPhone;
  final String orderStatus;
  final String paymentMethod;
  final int itemCount;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final double minimumOrder;
  final List<VendorOrderItem> items;
  final VendorAddress? address;
  final String? customerNotes;
  final String? cancellationReason;
  final String? rejectionReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? cancelledAt;
  final DateTime? deliveredAt;

  const VendorOrder({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.customerPhone,
    required this.orderStatus,
    required this.paymentMethod,
    this.itemCount = 0,
    this.subtotal = 0.0,
    this.deliveryFee = 0.0,
    this.total = 0.0,
    this.minimumOrder = 0.0,
    this.items = const [],
    this.address,
    this.customerNotes,
    this.cancellationReason,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
    this.cancelledAt,
    this.deliveredAt,
  });

  double get subTotal => subtotal;
  double get totalAmount => total;

  String get createdAtFormatted {
    if (createdAt == null) return '';
    final d = createdAt!;
    final year = d.year;
    final month = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    final hour = d.hour.toString().padLeft(2, '0');
    final min = d.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$min';
  }

  VendorOrder copyWith({
    String? orderStatus,
    String? rejectionReason,
    String? cancellationReason,
    DateTime? updatedAt,
    DateTime? cancelledAt,
    DateTime? deliveredAt,
  }) {
    return VendorOrder(
      id: id,
      orderNumber: orderNumber,
      customerName: customerName,
      customerPhone: customerPhone,
      orderStatus: orderStatus ?? this.orderStatus,
      paymentMethod: paymentMethod,
      itemCount: itemCount,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: total,
      minimumOrder: minimumOrder,
      items: items,
      address: address,
      customerNotes: customerNotes,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    orderNumber,
    customerName,
    customerPhone,
    orderStatus,
    paymentMethod,
    itemCount,
    subtotal,
    deliveryFee,
    total,
    minimumOrder,
    items,
    address,
    customerNotes,
    cancellationReason,
    rejectionReason,
    createdAt,
    updatedAt,
    cancelledAt,
    deliveredAt,
  ];
}
