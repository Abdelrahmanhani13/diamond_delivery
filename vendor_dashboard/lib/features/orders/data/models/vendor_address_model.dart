import '../../domain/entities/vendor_address.dart';

class VendorAddressModel extends VendorAddress {
  const VendorAddressModel({
    super.label,
    super.countryName,
    super.governorateName,
    super.cityName,
    super.areaText,
    super.street,
    super.buildingNumber,
    super.floorNumber,
    super.apartmentNumber,
    super.landmark,
    super.notes,
    super.latitude,
    super.longitude,
  });

  factory VendorAddressModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return const VendorAddressModel();
    }
    return VendorAddressModel(
      label: json['label'] as String?,
      countryName: json['countryName'] as String?,
      governorateName: json['governorateName'] as String?,
      cityName: json['cityName'] as String?,
      areaText: json['areaText'] as String?,
      street: json['street'] as String?,
      buildingNumber: json['buildingNumber'] as String?,
      floorNumber: json['floorNumber'] as String?,
      apartmentNumber: json['apartmentNumber'] as String?,
      landmark: json['landmark'] as String?,
      notes: json['notes'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
