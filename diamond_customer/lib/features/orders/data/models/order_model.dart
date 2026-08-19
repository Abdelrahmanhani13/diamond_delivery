import 'package:flutter/material.dart';
import 'order_item_model.dart';
import '../../../checkout/data/models/checkout_model.dart';

enum BackendOrderStatus {
  pending,
  accepted,
  preparing,
  readyForDelivery,
  outForDelivery,
  delivered,
  cancelled,
  rejected,
  unknown
}

extension OrderStatusMapping on String {
  BackendOrderStatus get toOrderStatus {
    switch (toLowerCase()) {
      case 'pending':
        return BackendOrderStatus.pending;
      case 'accepted':
        return BackendOrderStatus.accepted;
      case 'preparing':
        return BackendOrderStatus.preparing;
      case 'readyfordelivery':
        return BackendOrderStatus.readyForDelivery;
      case 'outfordelivery':
        return BackendOrderStatus.outForDelivery;
      case 'delivered':
        return BackendOrderStatus.delivered;
      case 'cancelled':
        return BackendOrderStatus.cancelled;
      case 'rejected':
        return BackendOrderStatus.rejected;
      default:
        return BackendOrderStatus.unknown;
    }
  }

  String get orderStatusLabel {
    switch (toLowerCase()) {
      case 'pending':
        return 'قيد الانتظار';
      case 'accepted':
        return 'تم القبول';
      case 'preparing':
        return 'جاري التجهيز';
      case 'readyfordelivery':
        return 'جاهز للتوصيل';
      case 'outfordelivery':
        return 'جاري التوصيل';
      case 'delivered':
        return 'تم التوصيل';
      case 'cancelled':
        return 'ملغي';
      case 'rejected':
        return 'مرفوض';
      default:
        return isEmpty ? 'غير معروف' : this;
    }
  }

  Color get orderStatusColor {
    switch (toLowerCase()) {
      case 'pending':
      case 'accepted':
      case 'preparing':
      case 'readyfordelivery':
      case 'outfordelivery':
        return const Color(0xFFF2A93B);
      case 'delivered':
        return const Color(0xFF149C2E);
      case 'cancelled':
      case 'rejected':
        return const Color(0xFFB31A1A);
      default:
        return const Color(0xFF8E8E93);
    }
  }
}

class OrderModel {
  final String id;
  final String orderNumber;
  final String vendorId;
  final String? vendorNameArabic;
  final String? vendorNameEnglish;
  final String? vendorLogoUrl;
  final String orderStatus;
  final String? paymentMethod;
  final List<OrderItemModel> items;
  final int? itemCount;
  final double? subtotal;
  final double? deliveryFee;
  final double total;
  final double? minimumOrder;
  final CheckoutAddressModel? address;
  final String? customerNotes;
  final String? cancellationReason;
  final String? rejectionReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? cancelledAt;
  final DateTime? deliveredAt;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.vendorId,
    this.vendorNameArabic,
    this.vendorNameEnglish,
    this.vendorLogoUrl,
    required this.orderStatus,
    this.paymentMethod,
    this.items = const [],
    this.itemCount,
    this.subtotal,
    this.deliveryFee,
    required this.total,
    this.minimumOrder,
    this.address,
    this.customerNotes,
    this.cancellationReason,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
    this.cancelledAt,
    this.deliveredAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String? ?? '',
      orderNumber: json['orderNumber'] as String? ?? '',
      vendorId: json['vendorId'] as String? ?? '',
      vendorNameArabic: json['vendorNameArabic'] as String?,
      vendorNameEnglish: json['vendorNameEnglish'] as String?,
      vendorLogoUrl: json['vendorLogoUrl'] as String?,
      orderStatus: json['orderStatus'] as String? ?? 'Pending',
      paymentMethod: json['paymentMethod'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      itemCount: (json['itemCount'] as num?)?.toInt(),
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      minimumOrder: (json['minimumOrder'] as num?)?.toDouble(),
      address: json['address'] != null
          ? CheckoutAddressModel.fromJson(
              json['address'] as Map<String, dynamic>,
            )
          : null,
      customerNotes: json['customerNotes'] as String?,
      cancellationReason: json['cancellationReason'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.tryParse(json['cancelledAt'] as String)
          : null,
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.tryParse(json['deliveredAt'] as String)
          : null,
    );
  }
}
