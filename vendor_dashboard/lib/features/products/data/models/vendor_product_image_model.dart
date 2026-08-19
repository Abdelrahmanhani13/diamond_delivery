// data/models/vendor_product_image_model.dart
import '../../domain/entities/vendor_product.dart';

class VendorProductImageModel extends VendorProductImage {
  const VendorProductImageModel({
    required super.id,
    required super.url,
    required super.isPrimary,
    super.displayOrder = 0,
    super.createdAt,
  });

  factory VendorProductImageModel.fromJson(Map<String, dynamic> json) {
    return VendorProductImageModel(
      id: json['id']?.toString() ?? '',
      url: json['imageUrl']?.toString() ?? '',
      isPrimary: json['isPrimary'] as bool? ?? false,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
