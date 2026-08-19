class CreateOrderRequest {
  final String addressId;
  final String paymentMethodId;
  final String? customerNotes;

  CreateOrderRequest({
    required this.addressId,
    required this.paymentMethodId,
    this.customerNotes,
  });

  Map<String, dynamic> toJson() => {
        'addressId': addressId,
        'paymentMethodId': paymentMethodId,
        'customerNotes': customerNotes ?? '',
      };
}

class CancelOrderRequest {
  final String reason;

  CancelOrderRequest({
    required this.reason,
  });

  Map<String, dynamic> toJson() => {
        'reason': reason,
      };
}
