import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.vendorId,
    super.vendorName,
    required super.nameArabic,
    required super.nameEnglish,
    super.descriptionArabic,
    super.descriptionEnglish,
    required super.imageUrls,
    required super.price,
    super.discountPrice,
    super.stockQuantity,
    required super.ratingAverage,
    super.ratingCount,
    required super.isFavorite,
    required super.isAvailable,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // شكل القائمة (GET /products, /products/{id}/related,
    // /vendors/{id}/products): بيرجع primaryImageUrl (String واحد).
    // شكل التفاصيل (GET /products/{id}): بيرجع images (List<Object>
    // فيها imageUrl لكل واحدة).
    final List<String> imageUrls;
    if (json['images'] is List) {
      imageUrls = (json['images'] as List<dynamic>)
          .map((e) => (e as Map<String, dynamic>)['imageUrl']?.toString() ?? '')
          .where((url) => url.isNotEmpty)
          .toList();
    } else {
      final primary = json['primaryImageUrl'] as String?;
      imageUrls = (primary != null && primary.isNotEmpty)
          ? [primary]
          : const [];
    }

    return ProductModel(
      id: json['id']?.toString() ?? '',
      vendorId: json['vendorId']?.toString() ?? '',
      vendorName: json['vendorName'] as String?,
      nameArabic: json['nameArabic']?.toString() ?? '',
      nameEnglish: json['nameEnglish']?.toString() ?? '',
      descriptionArabic: json['descriptionArabic'] as String?,
      descriptionEnglish: json['descriptionEnglish'] as String?,
      imageUrls: imageUrls,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      discountPrice: (json['discountPrice'] as num?)?.toDouble(),
      stockQuantity: (json['stockQuantity'] as num?)?.toInt() ?? 0,
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble() ?? 0,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
      isFavorite: json['isFavorite'] as bool? ?? false,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'nameArabic': nameArabic,
      'nameEnglish': nameEnglish,
      'descriptionArabic': descriptionArabic,
      'descriptionEnglish': descriptionEnglish,
      'price': price,
      'discountPrice': discountPrice,
      'stockQuantity': stockQuantity,
      'ratingAverage': ratingAverage,
      'ratingCount': ratingCount,
      'isFavorite': isFavorite,
      'isAvailable': isAvailable,
    };
  }
}
