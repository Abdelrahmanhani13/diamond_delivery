import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String vendorId;

  /// بيرجع بس في استجابة تفاصيل المنتج (GET /products/{id})،
  /// مش موجود في القوائم (list/related/vendor-products).
  final String? vendorName;

  final String nameArabic;
  final String nameEnglish;

  /// بيرجعوا بس في استجابة تفاصيل المنتج، مش موجودين في القوائم.
  final String? descriptionArabic;
  final String? descriptionEnglish;

  final List<String> imageUrls;
  final double price;
  final double? discountPrice;
  final int stockQuantity;
  final double ratingAverage;
  final int ratingCount;
  final bool isFavorite;
  final bool isAvailable;

  const Product({
    required this.id,
    required this.vendorId,
    this.vendorName,
    required this.nameArabic,
    required this.nameEnglish,
    this.descriptionArabic,
    this.descriptionEnglish,
    required this.imageUrls,
    required this.price,
    this.discountPrice,
    this.stockQuantity = 0,
    required this.ratingAverage,
    this.ratingCount = 0,
    required this.isFavorite,
    required this.isAvailable,
  });

  // ===================================================================
  // Convenience getters — نفس الأسماء اللي الـ views الحالية بتستخدمها
  // (product.name / product.description / product.rating) عشان تفضل
  // شغالة من غير أي تعديل فيها.
  // ===================================================================

  String get name => nameArabic.isNotEmpty ? nameArabic : nameEnglish;

  String get description {
    if (descriptionArabic != null && descriptionArabic!.isNotEmpty) {
      return descriptionArabic!;
    }
    return descriptionEnglish ?? '';
  }

  double get rating => ratingAverage;

  Product copyWith({
    bool? isFavorite,
    bool? isAvailable,
    List<String>? imageUrls,
  }) {
    return Product(
      id: id,
      vendorId: vendorId,
      vendorName: vendorName,
      nameArabic: nameArabic,
      nameEnglish: nameEnglish,
      descriptionArabic: descriptionArabic,
      descriptionEnglish: descriptionEnglish,
      imageUrls: imageUrls ?? this.imageUrls,
      price: price,
      discountPrice: discountPrice,
      stockQuantity: stockQuantity,
      ratingAverage: ratingAverage,
      ratingCount: ratingCount,
      isFavorite: isFavorite ?? this.isFavorite,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  @override
  List<Object?> get props => [
    id,
    vendorId,
    vendorName,
    nameArabic,
    nameEnglish,
    descriptionArabic,
    descriptionEnglish,
    imageUrls,
    price,
    discountPrice,
    stockQuantity,
    ratingAverage,
    ratingCount,
    isFavorite,
    isAvailable,
  ];
}
