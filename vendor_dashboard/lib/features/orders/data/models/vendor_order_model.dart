import '../../domain/entities/vendor_order.dart';
import 'vendor_order_item_model.dart';
import 'vendor_address_model.dart';

class VendorOrderModel extends VendorOrder {
  const VendorOrderModel({
    required super.id,
    required super.orderNumber,
    required super.customerName,
    required super.customerPhone,
    required super.orderStatus,
    required super.paymentMethod,
    super.itemCount,
    super.subtotal,
    super.deliveryFee,
    super.total,
    super.minimumOrder,
    super.items,
    super.address,
    super.customerNotes,
    super.cancellationReason,
    super.rejectionReason,
    super.createdAt,
    super.updatedAt,
    super.cancelledAt,
    super.deliveredAt,
  });

  factory VendorOrderModel.fromJson(dynamic json) {
    final map =
        (json is Map<String, dynamic> && json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : (json is Map<String, dynamic> ? json : <String, dynamic>{});

    final itemsList =
        (map['items'] as List<dynamic>?)
            ?.map(
              (e) => VendorOrderItemModel.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        [];

    final addressObj = map['address'] != null
        ? VendorAddressModel.fromJson(map['address'])
        : null;

    final itemsCountVal =
        (map['itemCount'] as num?)?.toInt() ?? itemsList.length;

    return VendorOrderModel(
      id: map['id']?.toString() ?? '',
      orderNumber: map['orderNumber'] as String? ?? '',
      customerName: map['customerName'] as String? ?? '',
      customerPhone: map['customerPhone'] as String? ?? '',
      orderStatus: map['orderStatus'] as String? ?? '',
      paymentMethod: map['paymentMethod'] as String? ?? '',
      itemCount: itemsCountVal,
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (map['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
      minimumOrder: (map['minimumOrder'] as num?)?.toDouble() ?? 0.0,
      items: itemsList,
      address: addressObj,
      customerNotes: map['customerNotes'] as String?,
      cancellationReason: map['cancellationReason'] as String?,
      rejectionReason: map['rejectionReason'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
      cancelledAt: map['cancelledAt'] != null
          ? DateTime.tryParse(map['cancelledAt'].toString())
          : null,
      deliveredAt: map['deliveredAt'] != null
          ? DateTime.tryParse(map['deliveredAt'].toString())
          : null,
    );
  }
}
