class AddToCartRequest {
  final String productId;
  final int quantity;

  AddToCartRequest({
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'quantity': quantity,
      };
}

class UpdateCartItemRequest {
  final int quantity;

  UpdateCartItemRequest({
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'quantity': quantity,
      };
}
