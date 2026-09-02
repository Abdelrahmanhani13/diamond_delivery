class VendorDashboardStatsModel {
  final int totalProducts;
  final int availableProducts;
  final int unavailableProducts;
  final int pendingOrders;
  final int preparingOrders;
  final int readyOrders;

  const VendorDashboardStatsModel({
    required this.totalProducts,
    required this.availableProducts,
    required this.unavailableProducts,
    required this.pendingOrders,
    required this.preparingOrders,
    required this.readyOrders,
  });

  factory VendorDashboardStatsModel.fromJson(dynamic json) {
    final map =
        (json is Map<String, dynamic> && json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : (json is Map<String, dynamic> ? json : <String, dynamic>{});

    return VendorDashboardStatsModel(
      totalProducts: (map['totalProducts'] as num?)?.toInt() ?? 0,
      availableProducts: (map['availableProducts'] as num?)?.toInt() ?? 0,
      unavailableProducts: (map['unavailableProducts'] as num?)?.toInt() ?? 0,
      pendingOrders: (map['pendingOrders'] as num?)?.toInt() ?? 0,
      preparingOrders: (map['preparingOrders'] as num?)?.toInt() ?? 0,
      readyOrders: (map['readyOrders'] as num?)?.toInt() ?? 0,
    );
  }
}
