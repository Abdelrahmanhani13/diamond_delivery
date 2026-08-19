import 'package:equatable/equatable.dart';

/// نتيجة الـ Geocoding (Reverse أو Search) من Nominatim — بنستخدمها
/// عشان نملأ حقول العنوان تلقائياً بعد ما المستخدم يحدد نقطة على
/// الخريطة، أو يختار نتيجة من البحث النصي.
class GeocodedAddress extends Equatable {
  final String country;
  final String city;
  final String area;
  final String street;
  final String displayName;
  final double latitude;
  final double longitude;

  const GeocodedAddress({
    required this.country,
    required this.city,
    required this.area,
    required this.street,
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
    country,
    city,
    area,
    street,
    displayName,
    latitude,
    longitude,
  ];
}
