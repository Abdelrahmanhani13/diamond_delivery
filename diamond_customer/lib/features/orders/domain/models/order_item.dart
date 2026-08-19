import 'package:flutter/material.dart';

enum OrderStatus { delivered, cancelled, active, completed }

extension OrderStatusX on OrderStatus {
  String get label => switch (this) {
        OrderStatus.delivered => 'تم التوصيل',
        OrderStatus.cancelled => 'ملغي',
        OrderStatus.active => 'قيد التنفيذ',
        OrderStatus.completed => 'مكتمل',
      };

  Color get color => switch (this) {
        OrderStatus.delivered => const Color(0xFF149C2E),
        OrderStatus.cancelled => const Color(0xFFB31A1A),
        OrderStatus.active => const Color(0xFFF2A93B),
        OrderStatus.completed => const Color(0xFF149C2E),
      };
}

/// UI-only order model matching the "طلباتي" list in the Figma.
class OrderItem {
  const OrderItem({
    required this.storeName,
    required this.dateLabel,
    required this.price,
    required this.itemsCount,
    required this.status,
    this.canReorder = true,
  });

  final String storeName;
  final String dateLabel;
  final double price;
  final int itemsCount;
  final OrderStatus status;
  final bool canReorder;
}
