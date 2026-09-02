import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../../features/profile/domain/entities/vendor_category.dart';
import '../../features/products/domain/entities/vendor_product.dart';

extension LocalizedBuildContextExtension on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);

  String tr(String key) => AppLocalizations.of(this).translate(key);

  bool get isArabic => AppLocalizations.of(this).isArabic;
}

extension LocalizedVendorCategoryExtension on VendorCategory {
  String getLocalizedName(BuildContext context) {
    if (context.isArabic) {
      return nameArabic.isNotEmpty ? nameArabic : nameEnglish;
    } else {
      return nameEnglish.isNotEmpty ? nameEnglish : nameArabic;
    }
  }
}

extension LocalizedVendorProductExtension on VendorProduct {
  String getLocalizedName(BuildContext context) {
    if (context.isArabic) {
      return nameArabic.isNotEmpty ? nameArabic : nameEnglish;
    } else {
      return nameEnglish.isNotEmpty ? nameEnglish : nameArabic;
    }
  }

  String getLocalizedDescription(BuildContext context) {
    if (context.isArabic) {
      return descriptionArabic.isNotEmpty
          ? descriptionArabic
          : descriptionEnglish;
    } else {
      return descriptionEnglish.isNotEmpty
          ? descriptionEnglish
          : descriptionArabic;
    }
  }
}
