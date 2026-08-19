// data/models/vendor_product_request_model.dart
class VendorProductRequestModel {
  final String subCategoryId;
  final String nameArabic;
  final String nameEnglish;
  final String? descriptionArabic;
  final String? descriptionEnglish;
  final double price;
  final double? discountPrice;
  final int stockQuantity;
  final String? sku;
  final String? barcode;
  final double? weight;

  const VendorProductRequestModel({
    required this.subCategoryId,
    required this.nameArabic,
    required this.nameEnglish,
    this.descriptionArabic,
    this.descriptionEnglish,
    required this.price,
    this.discountPrice,
    this.stockQuantity = 0,
    this.sku,
    this.barcode,
    this.weight,
  });

  Map<String, dynamic> toJson() {
    return {
      'subCategoryId': subCategoryId,
      'nameArabic': nameArabic,
      'nameEnglish': nameEnglish,
      'descriptionArabic': descriptionArabic,
      'descriptionEnglish': descriptionEnglish,
      'price': price,
      'discountPrice': discountPrice,
      'stockQuantity': stockQuantity,
      'sku': sku,
      'barcode': barcode,
      'weight': weight,
    };
  }
}
