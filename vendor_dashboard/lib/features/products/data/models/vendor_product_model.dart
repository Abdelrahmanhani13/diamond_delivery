// data/models/vendor_product_model.dart
import '../../domain/entities/vendor_product.dart';
import 'vendor_product_image_model.dart';

class VendorProductModel extends VendorProduct {
  const VendorProductModel({
    required super.id,
    required super.vendorId,
    super.vendorName,
    super.vendorCategoryId,
    super.vendorCategoryName,
    required super.subCategoryId,
    super.subCategoryNameArabic,
    super.subCategoryNameEnglish,
    required super.nameArabic,
    required super.nameEnglish,
    required super.descriptionArabic,
    required super.descriptionEnglish,
    required super.price,
    super.discountPrice,
    super.stockQuantity,
    super.sku,
    super.barcode,
    super.weight,
    super.ratingAverage,
    super.ratingCount,
    super.isAvailable,
    super.isFavorite,
    super.createdAt,
    super.updatedAt,
    super.images,
  });

  /// السواجر بيرجع الرد ملفوف جوه "data"، بس سيبنا احتياط لو جه خام
  /// (زي لما بنبعت الـ response بتاع upload image أو أي استخدام تاني).
  factory VendorProductModel.fromJson(Map<String, dynamic> json) {
    final map = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return VendorProductModel(
      id: map['id']?.toString() ?? '',
      vendorId: map['vendorId']?.toString() ?? '',
      vendorName: map['vendorName'] as String?,
      vendorCategoryId: map['vendorCategoryId']?.toString(),
      vendorCategoryName: map['vendorCategoryName'] as String?,
      subCategoryId: map['subCategoryId']?.toString() ?? '',
      subCategoryNameArabic: map['subCategoryNameArabic'] as String?,
      subCategoryNameEnglish: map['subCategoryNameEnglish'] as String?,
      nameArabic: map['nameArabic']?.toString() ?? '',
      nameEnglish: map['nameEnglish']?.toString() ?? '',
      descriptionArabic: map['descriptionArabic']?.toString() ?? '',
      descriptionEnglish: map['descriptionEnglish']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      discountPrice: (map['discountPrice'] as num?)?.toDouble(),
      stockQuantity: (map['stockQuantity'] as num?)?.toInt() ?? 0,
      sku: map['sku'] as String?,
      barcode: map['barcode'] as String?,
      weight: (map['weight'] as num?)?.toDouble(),
      ratingAverage: (map['ratingAverage'] as num?)?.toDouble() ?? 0,
      ratingCount: (map['ratingCount'] as num?)?.toInt() ?? 0,
      isAvailable: map['isAvailable'] as bool? ?? true,
      isFavorite: map['isFavorite'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
      images:
          (map['images'] as List<dynamic>?)
              ?.map(
                (e) =>
                    VendorProductImageModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );
  }
}
