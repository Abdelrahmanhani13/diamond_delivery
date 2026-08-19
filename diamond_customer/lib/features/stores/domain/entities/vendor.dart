import 'package:equatable/equatable.dart';

class Vendor extends Equatable {
  final String id;
  final String name;
  final String logoUrl;
  final String coverUrl;
  final double rating;
  final double deliveryFee;
  final double minimumOrder;
  final double distanceKm;
  final bool isOpen;
  final bool isFavorite;
  final String category;
  final String address;
  final String workingHours;

  const Vendor({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.coverUrl,
    required this.rating,
    required this.deliveryFee,
    required this.minimumOrder,
    required this.distanceKm,
    required this.isOpen,
    required this.isFavorite,
    required this.category,
    required this.address,
    required this.workingHours,
  });

  Vendor copyWith({
    String? id,
    String? name,
    String? logoUrl,
    String? coverUrl,
    double? rating,
    double? deliveryFee,
    double? minimumOrder,
    double? distanceKm,
    bool? isOpen,
    bool? isFavorite,
    String? category,
    String? address,
    String? workingHours,
  }) {
    return Vendor(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      rating: rating ?? this.rating,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      minimumOrder: minimumOrder ?? this.minimumOrder,
      distanceKm: distanceKm ?? this.distanceKm,
      isOpen: isOpen ?? this.isOpen,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
      address: address ?? this.address,
      workingHours: workingHours ?? this.workingHours,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    logoUrl,
    coverUrl,
    rating,
    deliveryFee,
    minimumOrder,
    distanceKm,
    isOpen,
    isFavorite,
    category,
    address,
    workingHours,
  ];
}
