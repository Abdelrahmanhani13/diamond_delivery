import '../../domain/entities/vendor_order_item.dart';

class VendorOrderItemModel extends VendorOrderItem {
  const VendorOrderItemModel({
    required super.id,
    required super.productId,
    required super.productName,
    super.productImageUrl,
    required super.unitPrice,
    required super.quantity,
    required super.totalPrice,
  });

  factory VendorOrderItemModel.fromJson(Map<String, dynamic> json) {
    return VendorOrderItemModel(
      id: json['id']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      productName: json['productName'] as String? ?? '',
      productImageUrl: json['productImageUrl'] as String?,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
