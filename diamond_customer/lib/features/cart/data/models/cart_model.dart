import 'cart_item_model.dart';

class CartModel {
  final String cartId;
  final String vendorId;
  final String vendorNameArabic;
  final String vendorNameEnglish;
  final String? vendorLogoUrl;
  final double vendorDeliveryFee;
  final double vendorMinimumOrder;
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double total;

  CartModel({
    required this.cartId,
    required this.vendorId,
    required this.vendorNameArabic,
    required this.vendorNameEnglish,
    this.vendorLogoUrl,
    required this.vendorDeliveryFee,
    required this.vendorMinimumOrder,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      cartId: json['cartId'] as String? ?? '',
      vendorId: json['vendorId'] as String? ?? '',
      vendorNameArabic: json['vendorNameArabic'] as String? ?? '',
      vendorNameEnglish: json['vendorNameEnglish'] as String? ?? '',
      vendorLogoUrl: json['vendorLogoUrl'] as String?,
      vendorDeliveryFee: (json['vendorDeliveryFee'] as num?)?.toDouble() ?? 0.0,
      vendorMinimumOrder:
          (json['vendorMinimumOrder'] as num?)?.toDouble() ?? 0.0,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'cartId': cartId,
        'vendorId': vendorId,
        'vendorNameArabic': vendorNameArabic,
        'vendorNameEnglish': vendorNameEnglish,
        'vendorLogoUrl': vendorLogoUrl,
        'vendorDeliveryFee': vendorDeliveryFee,
        'vendorMinimumOrder': vendorMinimumOrder,
        'items': items.map((e) => e.toJson()).toList(),
        'subtotal': subtotal,
        'deliveryFee': deliveryFee,
        'total': total,
      };
}
