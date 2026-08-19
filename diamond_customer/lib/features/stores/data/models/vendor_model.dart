import '../../domain/entities/vendor.dart';

class VendorModel extends Vendor {
  const VendorModel({
    required super.id,
    required super.name,
    required super.logoUrl,
    required super.coverUrl,
    required super.rating,
    required super.deliveryFee,
    required super.minimumOrder,
    required super.distanceKm,
    required super.isOpen,
    required super.isFavorite,
    required super.category,
    required super.address,
    required super.workingHours,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      deliveryFee: (json['deliveryFee'] ?? 0.0).toDouble(),
      minimumOrder: (json['minimumOrder'] ?? 0.0).toDouble(),
      distanceKm: (json['distanceKm'] ?? 0.0).toDouble(),
      isOpen: json['isOpen'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
      category: json['category'] ?? '',
      address: json['address'] ?? '',
      workingHours: json['workingHours'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'coverUrl': coverUrl,
      'rating': rating,
      'deliveryFee': deliveryFee,
      'minimumOrder': minimumOrder,
      'distanceKm': distanceKm,
      'isOpen': isOpen,
      'isFavorite': isFavorite,
      'category': category,
      'address': address,
      'workingHours': workingHours,
    };
  }
}
