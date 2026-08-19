import 'package:diamond_customer/features/cart/data/models/cart_model.dart';

class PaymentMethodModel {
  final String id;
  final String name;

  PaymentMethodModel({
    required this.id,
    required this.name,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class CheckoutIssueModel {
  final String code;
  final String message;
  final String? productId;

  CheckoutIssueModel({
    required this.code,
    required this.message,
    this.productId,
  });

  factory CheckoutIssueModel.fromJson(Map<String, dynamic> json) {
    return CheckoutIssueModel(
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      productId: json['productId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'productId': productId,
      };
}

class CheckoutAddressModel {
  final String id;
  final String? label;
  final String? countryName;
  final String? governorateName;
  final String? cityName;
  final String? areaText;
  final String? street;
  final String? buildingNumber;
  final String? floorNumber;
  final String? apartmentNumber;
  final String? landmark;
  final String? notes;
  final double? latitude;
  final double? longitude;

  CheckoutAddressModel({
    required this.id,
    this.label,
    this.countryName,
    this.governorateName,
    this.cityName,
    this.areaText,
    this.street,
    this.buildingNumber,
    this.floorNumber,
    this.apartmentNumber,
    this.landmark,
    this.notes,
    this.latitude,
    this.longitude,
  });

  factory CheckoutAddressModel.fromJson(Map<String, dynamic> json) {
    return CheckoutAddressModel(
      id: json['id'] as String? ?? '',
      label: json['label'] as String?,
      countryName: json['countryName'] as String?,
      governorateName: json['governorateName'] as String?,
      cityName: json['cityName'] as String?,
      areaText: json['areaText'] as String?,
      street: json['street'] as String?,
      buildingNumber: json['buildingNumber'] as String?,
      floorNumber: json['floorNumber'] as String?,
      apartmentNumber: json['apartmentNumber'] as String?,
      landmark: json['landmark'] as String?,
      notes: json['notes'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  String get fullAddressText {
    final parts = [
      if (label != null && label!.isNotEmpty) label,
      if (cityName != null && cityName!.isNotEmpty) cityName,
      if (areaText != null && areaText!.isNotEmpty) areaText,
      if (street != null && street!.isNotEmpty) street,
      if (buildingNumber != null && buildingNumber!.isNotEmpty) 'مبنى $buildingNumber',
    ];
    return parts.join('، ');
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'countryName': countryName,
        'governorateName': governorateName,
        'cityName': cityName,
        'areaText': areaText,
        'street': street,
        'buildingNumber': buildingNumber,
        'floorNumber': floorNumber,
        'apartmentNumber': apartmentNumber,
        'landmark': landmark,
        'notes': notes,
        'latitude': latitude,
        'longitude': longitude,
      };
}

class CheckoutModel {
  final CartModel? cart;
  final CheckoutAddressModel? selectedAddress;
  final String? selectedPaymentMethodId;
  final String? selectedPaymentMethodName;
  final List<PaymentMethodModel> availablePaymentMethods;
  final double minimumOrder;
  final bool isEligibleToCheckout;
  final List<CheckoutIssueModel> issues;

  CheckoutModel({
    this.cart,
    this.selectedAddress,
    this.selectedPaymentMethodId,
    this.selectedPaymentMethodName,
    required this.availablePaymentMethods,
    required this.minimumOrder,
    required this.isEligibleToCheckout,
    required this.issues,
  });

  factory CheckoutModel.fromJson(Map<String, dynamic> json) {
    return CheckoutModel(
      cart: json['cart'] != null
          ? CartModel.fromJson(json['cart'] as Map<String, dynamic>)
          : null,
      selectedAddress: json['selectedAddress'] != null
          ? CheckoutAddressModel.fromJson(
              json['selectedAddress'] as Map<String, dynamic>,
            )
          : null,
      selectedPaymentMethodId: json['selectedPaymentMethodId'] as String?,
      selectedPaymentMethodName: json['selectedPaymentMethodName'] as String?,
      availablePaymentMethods: (json['availablePaymentMethods'] as List<dynamic>?)
              ?.map((e) => PaymentMethodModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      minimumOrder: (json['minimumOrder'] as num?)?.toDouble() ?? 0.0,
      isEligibleToCheckout: json['isEligibleToCheckout'] as bool? ?? false,
      issues: (json['issues'] as List<dynamic>?)
              ?.map((e) => CheckoutIssueModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
