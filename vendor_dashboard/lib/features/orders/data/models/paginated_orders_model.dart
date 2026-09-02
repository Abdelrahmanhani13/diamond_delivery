import '../../domain/entities/vendor_order.dart';
import 'vendor_order_model.dart';

class PaginatedOrdersModel {
  final List<VendorOrder> items;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const PaginatedOrdersModel({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory PaginatedOrdersModel.fromJson(dynamic json) {
    final map =
        (json is Map<String, dynamic> && json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : (json is Map<String, dynamic> ? json : <String, dynamic>{});

    final rawItems = map['items'] as List<dynamic>? ?? [];
    final itemsList = rawItems
        .map((e) => VendorOrderModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return PaginatedOrdersModel(
      items: itemsList,
      pageNumber: (map['pageNumber'] as num?)?.toInt() ?? 1,
      pageSize: (map['pageSize'] as num?)?.toInt() ?? 10,
      totalCount: (map['totalCount'] as num?)?.toInt() ?? 0,
      totalPages: (map['totalPages'] as num?)?.toInt() ?? 0,
      hasPreviousPage: map['hasPreviousPage'] as bool? ?? false,
      hasNextPage: map['hasNextPage'] as bool? ?? false,
    );
  }
}
