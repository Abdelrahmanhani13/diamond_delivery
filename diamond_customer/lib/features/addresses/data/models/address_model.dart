import 'package:diamond_customer/features/addresses/domain/entities/address_domain_entity.dart';

class AddressModel extends Address {
  const AddressModel({
    required super.id,
    required super.addressTypeId,
    required super.countryId,
    required super.governorateId,
    required super.cityId,
    required super.areaText,
    required super.label,
    required super.street,
    required super.buildingNumber,
    required super.floorNumber,
    required super.apartmentNumber,
    required super.landmark,
    super.notes,
    required super.latitude,
    required super.longitude,
    required super.isDefault,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id']?.toString() ?? '',
      addressTypeId: json['addressTypeId']?.toString() ?? '',
      countryId: json['countryId']?.toString() ?? '',
      governorateId: json['governorateId']?.toString() ?? '',
      cityId: json['cityId']?.toString() ?? '',
      areaText: json['areaText'] ?? '',
      label: json['label'] ?? '',
      street: json['street'] ?? '',
      buildingNumber: json['buildingNumber'] ?? '',
      floorNumber: json['floorNumber'] ?? '',
      apartmentNumber: json['apartmentNumber'] ?? '',
      landmark: json['landmark'] ?? '',
      notes: json['notes'],
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      isDefault: json['isDefault'] ?? false,
    );
  }

  factory AddressModel.fromEntity(Address address) {
    return AddressModel(
      id: address.id,
      addressTypeId: address.addressTypeId,
      countryId: address.countryId,
      governorateId: address.governorateId,
      cityId: address.cityId,
      areaText: address.areaText,
      label: address.label,
      street: address.street,
      buildingNumber: address.buildingNumber,
      floorNumber: address.floorNumber,
      apartmentNumber: address.apartmentNumber,
      landmark: address.landmark,
      notes: address.notes,
      latitude: address.latitude,
      longitude: address.longitude,
      isDefault: address.isDefault,
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      'addressTypeId': addressTypeId,
      'countryId': countryId,
      'governorateId': governorateId,
      'cityId': cityId,
      'areaText': areaText,
      'label': label,
      'street': street,
      'buildingNumber': buildingNumber,
      'floorNumber': floorNumber,
      'apartmentNumber': apartmentNumber,
      'landmark': landmark,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
    };
    if (notes != null) map['notes'] = notes!;
    return map;
  }
}
