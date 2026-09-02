import '../../domain/entities/vendor_category.dart';

class VendorCategoryModel extends VendorCategory {
  const VendorCategoryModel({
    required super.id,
    required super.nameArabic,
    required super.nameEnglish,
    super.imageUrl,
    super.displayOrder,
  });

  factory VendorCategoryModel.fromJson(Map<String, dynamic> json) {
    return VendorCategoryModel(
      id: json['id'] as String? ?? '',
      nameArabic: json['nameArabic'] as String? ?? '',
      nameEnglish: json['nameEnglish'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameArabic': nameArabic,
      'nameEnglish': nameEnglish,
      'imageUrl': imageUrl,
      'displayOrder': displayOrder,
    };
  }
}
