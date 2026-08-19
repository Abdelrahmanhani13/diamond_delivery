import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String id;
  final String addressTypeId;
  final String countryId;
  final String governorateId;
  final String cityId;
  final String areaText;
  final String label;
  final String street;
  final String buildingNumber;
  final String floorNumber;
  final String apartmentNumber;
  final String landmark;
  final String? notes;
  final double latitude;
  final double longitude;
  final bool isDefault;

  const Address({
    required this.id,
    required this.addressTypeId,
    required this.countryId,
    required this.governorateId,
    required this.cityId,
    required this.areaText,
    required this.label,
    required this.street,
    required this.buildingNumber,
    required this.floorNumber,
    required this.apartmentNumber,
    required this.landmark,
    this.notes,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
  });

  /// نص مختصر للعرض في الكارت/القوائم
  String get shortSummary =>
      [areaText, street].where((e) => e.trim().isNotEmpty).join('، ');

  Address copyWith({
    String? id,
    String? addressTypeId,
    String? countryId,
    String? governorateId,
    String? cityId,
    String? areaText,
    String? label,
    String? street,
    String? buildingNumber,
    String? floorNumber,
    String? apartmentNumber,
    String? landmark,
    String? notes,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      addressTypeId: addressTypeId ?? this.addressTypeId,
      countryId: countryId ?? this.countryId,
      governorateId: governorateId ?? this.governorateId,
      cityId: cityId ?? this.cityId,
      areaText: areaText ?? this.areaText,
      label: label ?? this.label,
      street: street ?? this.street,
      buildingNumber: buildingNumber ?? this.buildingNumber,
      floorNumber: floorNumber ?? this.floorNumber,
      apartmentNumber: apartmentNumber ?? this.apartmentNumber,
      landmark: landmark ?? this.landmark,
      notes: notes ?? this.notes,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [
    id,
    addressTypeId,
    countryId,
    governorateId,
    cityId,
    areaText,
    label,
    street,
    buildingNumber,
    floorNumber,
    apartmentNumber,
    landmark,
    notes,
    latitude,
    longitude,
    isDefault,
  ];
}
