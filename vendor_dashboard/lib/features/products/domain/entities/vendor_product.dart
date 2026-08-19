// domain/entities/vendor_product.dart
class VendorProductImage {
  final String id;
  final String url;
  final bool isPrimary;
  final int displayOrder;
  final DateTime? createdAt;

  const VendorProductImage({
    required this.id,
    required this.url,
    required this.isPrimary,
    this.displayOrder = 0,
    this.createdAt,
  });
}

class VendorProduct {
  final String id;
  final String vendorId;
  final String? vendorName;
  final String? vendorCategoryId;
  final String? vendorCategoryName;
  final String subCategoryId;
  final String? subCategoryNameArabic;
  final String? subCategoryNameEnglish;
  final String nameArabic;
  final String nameEnglish;
  final String descriptionArabic;
  final String descriptionEnglish;
  final double price;
  final double? discountPrice;
  final int stockQuantity;
  final String? sku;
  final String? barcode;
  final double? weight;
  final double ratingAverage;
  final int ratingCount;
  final bool isAvailable;
  final bool isFavorite;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<VendorProductImage> images;

  const VendorProduct({
    required this.id,
    required this.vendorId,
    this.vendorName,
    this.vendorCategoryId,
    this.vendorCategoryName,
    required this.subCategoryId,
    this.subCategoryNameArabic,
    this.subCategoryNameEnglish,
    required this.nameArabic,
    required this.nameEnglish,
    required this.descriptionArabic,
    required this.descriptionEnglish,
    required this.price,
    this.discountPrice,
    this.stockQuantity = 0,
    this.sku,
    this.barcode,
    this.weight,
    this.ratingAverage = 0,
    this.ratingCount = 0,
    this.isAvailable = true,
    this.isFavorite = false,
    this.createdAt,
    this.updatedAt,
    this.images = const [],
  });

  /// Convenience getters عشان الـ UI الحالي (زي ProductItemCard) بيستخدم
  /// name/description مباشرة من غير ما يفرق عربي/انجليزي.
  /// حاليًا بترجع النسخة العربية كـ default (التطبيق RTL)، وترجع
  /// الإنجليزي لو العربي فاضي.
  String get name => nameArabic.isNotEmpty ? nameArabic : nameEnglish;

  String get description =>
      descriptionArabic.isNotEmpty ? descriptionArabic : descriptionEnglish;

  /// الصورة الرئيسية لو موجودة، وإلا أول صورة، وإلا null.
  VendorProductImage? get primaryImage {
    if (images.isEmpty) return null;
    for (final img in images) {
      if (img.isPrimary) return img;
    }
    return images.first;
  }

  VendorProduct copyWith({
    bool? isAvailable,
    List<VendorProductImage>? images,
  }) {
    return VendorProduct(
      id: id,
      vendorId: vendorId,
      vendorName: vendorName,
      vendorCategoryId: vendorCategoryId,
      vendorCategoryName: vendorCategoryName,
      subCategoryId: subCategoryId,
      subCategoryNameArabic: subCategoryNameArabic,
      subCategoryNameEnglish: subCategoryNameEnglish,
      nameArabic: nameArabic,
      nameEnglish: nameEnglish,
      descriptionArabic: descriptionArabic,
      descriptionEnglish: descriptionEnglish,
      price: price,
      discountPrice: discountPrice,
      stockQuantity: stockQuantity,
      sku: sku,
      barcode: barcode,
      weight: weight,
      ratingAverage: ratingAverage,
      ratingCount: ratingCount,
      isAvailable: isAvailable ?? this.isAvailable,
      isFavorite: isFavorite,
      createdAt: createdAt,
      updatedAt: updatedAt,
      images: images ?? this.images,
    );
  }
}
