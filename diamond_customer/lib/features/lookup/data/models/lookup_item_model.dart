import 'package:flutter/widgets.dart';
import '../../domain/entities/lookup_item.dart';

class LookupItemModel extends LookupItem {
  const LookupItemModel({
    required super.id,
    required super.nameEn,
    required super.nameAr,
  });

  factory LookupItemModel.fromJson(Map<String, dynamic> json) {
    return LookupItemModel(
      id: json['id']?.toString() ?? '',
      nameEn: json['nameEn'] as String? ?? json['name'] as String? ?? '',
      nameAr: json['nameAr'] as String? ?? json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameAr': nameAr,
    };
  }

  /// Helper to get the localized name based on the current locale.
  /// Assuming RTL (Arabic) is the default or fallback if locale can't be resolved easily.
  String getLocalizedName(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    return isArabic ? nameAr : nameEn;
  }
}
