import 'package:vendor_dashboard/features/addresses/domain/entities/geocoded_address_entity_representing_a_reverse_forward_geocoding_result.dart';

class GeocodedAddressModel extends GeocodedAddress {
  const GeocodedAddressModel({
    required super.country,
    required super.city,
    required super.area,
    required super.street,
    required super.displayName,
    required super.latitude,
    required super.longitude,
  });

  /// نوميناتيم بترجع أسماء حقول مختلفة حسب الدولة/المدينة (مثلاً
  /// "town" بدل "city" في المناطق الريفية)، فبنجرب أكتر من مفتاح
  /// بديل لكل حقل بدل ما نعتمد على واحد بس ويطلع فاضي غالباً.
  factory GeocodedAddressModel.fromNominatimJson(Map<String, dynamic> json) {
    final address = (json['address'] as Map<String, dynamic>?) ?? const {};

    String pick(List<String> keys) {
      for (final key in keys) {
        final value = address[key];
        if (value is String && value.trim().isNotEmpty) return value;
      }
      return '';
    }

    return GeocodedAddressModel(
      country: pick(['country']),
      city: pick(['city', 'town', 'village', 'municipality', 'state']),
      area: pick(['suburb', 'neighbourhood', 'city_district', 'quarter']),
      street: pick(['road', 'pedestrian', 'footway']),
      displayName: json['display_name']?.toString() ?? '',
      latitude: double.tryParse(json['lat']?.toString() ?? '') ?? 0.0,
      longitude: double.tryParse(json['lon']?.toString() ?? '') ?? 0.0,
    );
  }
}
