/// UI-only model for a product/store card (e.g. "برجر هاوس").
class ProductItem {
  const ProductItem({
    required this.name,
    required this.subtitle,
    required this.rating,
    required this.reviewsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    this.badgeLabel,
    this.discountLabel,
    this.imageUrl,
  });

  final String name;
  final String subtitle;
  final double rating;
  final int reviewsCount;
  final String deliveryTime;
  final String deliveryFee;
  final String? badgeLabel;
  final String? discountLabel;
  final String? imageUrl;
}
