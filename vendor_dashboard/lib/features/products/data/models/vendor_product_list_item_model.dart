// data/models/vendor_product_list_item_model.dart
import '../../domain/entities/vendor_product.dart';
import 'vendor_product_image_model.dart';

/// الـ GET /Vendor/products (list) بيرجع نسخة "خفيفة" من المنتج، من غير
/// وصف/sku/barcode/weight وبيرجع primaryImageUrl بدل images كاملة.
/// بنحولها لنفس الـ VendorProduct entity عشان الـ UI الحالي
/// (ProductItemCard) يشتغل من غير أي تعديل.
class VendorProductListItemModel extends VendorProduct {
  const VendorProductListItemModel({
    required super.id,
    required super.vendorId,
    required super.subCategoryId,
    required super.nameArabic,
    required super.nameEnglish,
    required super.price,
    super.discountPrice,
    super.stockQuantity,
    super.ratingAverage,
    super.ratingCount,
    super.isAvailable,
    super.isFavorite,
    super.createdAt,
    super.images,
  }) : super(descriptionArabic: '', descriptionEnglish: '');

  factory VendorProductListItemModel.fromJson(Map<String, dynamic> json) {
    final primaryImageUrl = json['primaryImageUrl'] as String?;
    return VendorProductListItemModel(
      id: json['id']?.toString() ?? '',
      vendorId: json['vendorId']?.toString() ?? '',
      subCategoryId: json['subCategoryId']?.toString() ?? '',
      nameArabic: json['nameArabic']?.toString() ?? '',
      nameEnglish: json['nameEnglish']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      discountPrice: (json['discountPrice'] as num?)?.toDouble(),
      stockQuantity: (json['stockQuantity'] as num?)?.toInt() ?? 0,
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble() ?? 0,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
      isAvailable: json['isAvailable'] as bool? ?? true,
      isFavorite: json['isFavorite'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      images: primaryImageUrl != null && primaryImageUrl.isNotEmpty
          ? [
              VendorProductImageModel(
                id: 'primary',
                url: primaryImageUrl,
                isPrimary: true,
              ),
            ]
          : const [],
    );
  }
}

class VendorProductPageModel {
  final List<VendorProductListItemModel> items;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasNextPage;

  const VendorProductPageModel({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasNextPage,
  });

  factory VendorProductPageModel.fromJson(Map<String, dynamic> json) {
    final map = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return VendorProductPageModel(
      items:
          (map['items'] as List<dynamic>?)
              ?.map(
                (e) => VendorProductListItemModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
      pageNumber: (map['pageNumber'] as num?)?.toInt() ?? 1,
      pageSize: (map['pageSize'] as num?)?.toInt() ?? 20,
      totalCount: (map['totalCount'] as num?)?.toInt() ?? 0,
      totalPages: (map['totalPages'] as num?)?.toInt() ?? 0,
      hasNextPage: map['hasNextPage'] as bool? ?? false,
    );
  }
}
