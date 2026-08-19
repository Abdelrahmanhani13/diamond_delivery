import 'package:equatable/equatable.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../stores/domain/entities/vendor.dart';
import '../../../products/domain/entities/product.dart';

class BannerEntity extends Equatable {
  final String id;
  final String title;
  final String imageUrl;
  final String? tag;
  final String? ctaLabel;

  const BannerEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.tag,
    this.ctaLabel,
  });

  @override
  List<Object?> get props => [id, title, imageUrl, tag, ctaLabel];
}

class HomeData extends Equatable {
  final String greeting;
  final List<BannerEntity> banners;
  final List<CategoryEntity> categories;
  final List<Vendor> featuredVendors;
  final List<Vendor> nearbyVendors;
  final List<Product> featuredProducts;
  final List<Product> latestProducts;

  const HomeData({
    required this.greeting,
    required this.banners,
    required this.categories,
    required this.featuredVendors,
    required this.nearbyVendors,
    required this.featuredProducts,
    required this.latestProducts,
  });

  @override
  List<Object?> get props => [
        greeting,
        banners,
        categories,
        featuredVendors,
        nearbyVendors,
        featuredProducts,
        latestProducts,
      ];
}
