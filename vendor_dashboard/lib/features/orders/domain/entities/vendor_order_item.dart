import 'package:equatable/equatable.dart';

class VendorOrderItem extends Equatable {
  final String id;
  final String productId;
  final String productName;
  final String? productImageUrl;
  final double unitPrice;
  final int quantity;
  final double totalPrice;

  const VendorOrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImageUrl,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
  });

  String get productNameArabic => productName;

  @override
  List<Object?> get props => [
    id,
    productId,
    productName,
    productImageUrl,
    unitPrice,
    quantity,
    totalPrice,
  ];
}
