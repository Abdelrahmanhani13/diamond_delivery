import 'package:equatable/equatable.dart';

class VendorAddress extends Equatable {
  final String? label;
  final String? countryName;
  final String? governorateName;
  final String? cityName;
  final String? areaText;
  final String? street;
  final String? buildingNumber;
  final String? floorNumber;
  final String? apartmentNumber;
  final String? landmark;
  final String? notes;
  final double latitude;
  final double longitude;

  const VendorAddress({
    this.label,
    this.countryName,
    this.governorateName,
    this.cityName,
    this.areaText,
    this.street,
    this.buildingNumber,
    this.floorNumber,
    this.apartmentNumber,
    this.landmark,
    this.notes,
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  String get fullAddressText {
    final parts = [
      if (street != null && street!.isNotEmpty) street,
      if (buildingNumber != null && buildingNumber!.isNotEmpty)
        'مبنى $buildingNumber',
      if (floorNumber != null && floorNumber!.isNotEmpty) 'طابق $floorNumber',
      if (apartmentNumber != null && apartmentNumber!.isNotEmpty)
        'شقة $apartmentNumber',
      if (areaText != null && areaText!.isNotEmpty) areaText,
      if (cityName != null && cityName!.isNotEmpty) cityName,
      if (governorateName != null && governorateName!.isNotEmpty)
        governorateName,
    ];
    return parts.isEmpty ? 'لا يوجد عنوان تفصيلي' : parts.join('، ');
  }

  String get formattedAddress => fullAddressText;

  @override
  List<Object?> get props => [
    label,
    countryName,
    governorateName,
    cityName,
    areaText,
    street,
    buildingNumber,
    floorNumber,
    apartmentNumber,
    landmark,
    notes,
    latitude,
    longitude,
  ];
}
