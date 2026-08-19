class CartItemModel {
  final String productId;
  final String nameArabic;
  final String nameEnglish;
  final String? primaryImageUrl;
  final double unitPrice;
  final int quantity;
  final double itemTotal;
  final bool isAvailable;
  final int stockQuantity;

  CartItemModel({
    required this.productId,
    required this.nameArabic,
    required this.nameEnglish,
    this.primaryImageUrl,
    required this.unitPrice,
    required this.quantity,
    required this.itemTotal,
    required this.isAvailable,
    required this.stockQuantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] as String? ?? '',
      nameArabic: json['nameArabic'] as String? ?? '',
      nameEnglish: json['nameEnglish'] as String? ?? '',
      primaryImageUrl: json['primaryImageUrl'] as String?,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      itemTotal: (json['itemTotal'] as num?)?.toDouble() ?? 0.0,
      isAvailable: json['isAvailable'] as bool? ?? true,
      stockQuantity: (json['stockQuantity'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'nameArabic': nameArabic,
        'nameEnglish': nameEnglish,
        'primaryImageUrl': primaryImageUrl,
        'unitPrice': unitPrice,
        'quantity': quantity,
        'itemTotal': itemTotal,
        'isAvailable': isAvailable,
        'stockQuantity': stockQuantity,
      };
}
