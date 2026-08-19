// data/models/vendor_profile_model.dart
import '../../domain/entities/vendor_profile.dart';

class VendorProfileModel extends VendorProfile {
  const VendorProfileModel({
    required super.id,
    required super.userId,
    required super.vendorCategoryId,
    super.vendorCategoryName,
    required super.storeName,
    super.storeNameEn,
    super.description,
    super.descriptionEn,
    super.logoUrl,
    super.coverUrl,
    super.phone,
    super.whatsappNumber,
    required super.email,
    super.latitude,
    super.longitude,
    super.address,
    super.openTime,
    super.closeTime,
    super.isOpenNow,
    super.deliveryFee,
    super.minimumOrder,
    super.ratingAverage,
    super.ratingCount,
    super.status,
    super.isVerified,
    super.isFavorite,
    super.rejectionReason,
    super.createdAt,
    super.updatedAt,
  });

  /// بيقبل الـ response الخام سواء كان ApiResponse كامل (فيه 'data')
  /// أو الـ object بتاع البروفايل مباشرة.
  factory VendorProfileModel.fromJson(dynamic json) {
    final map =
        (json is Map<String, dynamic> && json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : (json as Map<String, dynamic>);

    return VendorProfileModel(
      id: map['id']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      vendorCategoryId: map['vendorCategoryId']?.toString() ?? '',
      vendorCategoryName: map['vendorCategoryName'] as String?,
      storeName: map['nameArabic'] as String? ?? '',
      storeNameEn: map['nameEnglish'] as String?,
      description: map['descriptionArabic'] as String?,
      descriptionEn: map['descriptionEnglish'] as String?,
      logoUrl: map['logoUrl'] as String?,
      coverUrl: map['coverUrl'] as String?,
      phone: map['phoneNumber'] as String?,
      whatsappNumber: map['whatsappNumber'] as String?,
      email: map['email'] as String? ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      address: map['address'] as String?,
      openTime: map['openTime'] as String?,
      closeTime: map['closeTime'] as String?,
      isOpenNow: map['isOpenNow'] as bool? ?? false,
      deliveryFee: (map['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      minimumOrder: (map['minimumOrder'] as num?)?.toDouble() ?? 0.0,
      ratingAverage: (map['ratingAverage'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (map['ratingCount'] as num?)?.toInt() ?? 0,
      status: map['status'] as String?,
      isVerified: map['isVerified'] as bool? ?? false,
      isFavorite: map['isFavorite'] as bool? ?? false,
      rejectionReason: map['rejectionReason'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
    );
  }

  /// بيحول أي VendorProfile (حتى لو مش Model، زي بعد copyWith) لـ Model
  /// عشان نقدر نخزنه أو نبعته تاني.
  factory VendorProfileModel.fromEntity(VendorProfile entity) {
    return VendorProfileModel(
      id: entity.id,
      userId: entity.userId,
      vendorCategoryId: entity.vendorCategoryId,
      vendorCategoryName: entity.vendorCategoryName,
      storeName: entity.storeName,
      storeNameEn: entity.storeNameEn,
      description: entity.description,
      descriptionEn: entity.descriptionEn,
      logoUrl: entity.logoUrl,
      coverUrl: entity.coverUrl,
      phone: entity.phone,
      whatsappNumber: entity.whatsappNumber,
      email: entity.email,
      latitude: entity.latitude,
      longitude: entity.longitude,
      address: entity.address,
      openTime: entity.openTime,
      closeTime: entity.closeTime,
      isOpenNow: entity.isOpenNow,
      deliveryFee: entity.deliveryFee,
      minimumOrder: entity.minimumOrder,
      ratingAverage: entity.ratingAverage,
      ratingCount: entity.ratingCount,
      status: entity.status,
      isVerified: entity.isVerified,
      isFavorite: entity.isFavorite,
      rejectionReason: entity.rejectionReason,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
