import '../../domain/entities/home_data.dart';
import '../../../categories/data/models/category_model.dart';
import '../../../stores/data/models/vendor_model.dart';
import '../../../products/data/models/product_model.dart';

class BannerModel extends BannerEntity {
  const BannerModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    super.tag,
    super.ctaLabel,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      tag: json['tag'],
      ctaLabel: json['ctaLabel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'tag': tag,
      'ctaLabel': ctaLabel,
    };
  }
}

class HomeDataModel extends HomeData {
  const HomeDataModel({
    required super.greeting,
    required super.banners,
    required super.categories,
    required super.featuredVendors,
    required super.nearbyVendors,
    required super.featuredProducts,
    required super.latestProducts,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      greeting: json['greeting'] ?? 'مرحباً بك',
      banners: (json['banners'] as List<dynamic>?)
              ?.map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      featuredVendors: (json['featuredVendors'] as List<dynamic>?)
              ?.map((e) => VendorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      nearbyVendors: (json['nearbyVendors'] as List<dynamic>?)
              ?.map((e) => VendorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      featuredProducts: (json['featuredProducts'] as List<dynamic>?)
              ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      latestProducts: (json['latestProducts'] as List<dynamic>?)
              ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'greeting': greeting,
      'banners': banners.map((b) => (b as BannerModel).toJson()).toList(),
      'categories': categories.map((c) => (c as CategoryModel).toJson()).toList(),
      'featuredVendors': featuredVendors.map((v) => (v as VendorModel).toJson()).toList(),
      'nearbyVendors': nearbyVendors.map((v) => (v as VendorModel).toJson()).toList(),
      'featuredProducts': featuredProducts.map((p) => (p as ProductModel).toJson()).toList(),
      'latestProducts': latestProducts.map((p) => (p as ProductModel).toJson()).toList(),
    };
  }
}
