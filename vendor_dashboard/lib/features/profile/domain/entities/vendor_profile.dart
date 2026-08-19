// domain/entities/vendor_profile.dart

/// Entity نظيف (Domain layer) بيمثل بروفايل التاجر.
/// أسماء الحقول اتبنت عشان تطابق استخدام الـ UI (storeName, phone, description..)
/// مع الاحتفاظ بباقي الحقول اللي راجعة من الـ API عشان نقدر نبعتها تاني
/// في الـ PUT request من غير ما نفقد بيانات.
class VendorProfile {
  final String id;
  final String userId;
  final String vendorCategoryId;
  final String? vendorCategoryName;

  final String storeName; // nameArabic
  final String? storeNameEn; // nameEnglish

  final String? description; // descriptionArabic
  final String? descriptionEn; // descriptionEnglish

  final String? logoUrl;
  final String? coverUrl;

  final String? phone; // phoneNumber
  final String? whatsappNumber;
  final String email;

  final double latitude;
  final double longitude;
  final String? address;

  final String? openTime;
  final String? closeTime;
  final bool isOpenNow;

  final double deliveryFee;
  final double minimumOrder;

  final double ratingAverage;
  final int ratingCount;

  final String? status;
  final bool isVerified;
  final bool isFavorite;
  final String? rejectionReason;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const VendorProfile({
    required this.id,
    required this.userId,
    required this.vendorCategoryId,
    this.vendorCategoryName,
    required this.storeName,
    this.storeNameEn,
    this.description,
    this.descriptionEn,
    this.logoUrl,
    this.coverUrl,
    this.phone,
    this.whatsappNumber,
    required this.email,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.address,
    this.openTime,
    this.closeTime,
    this.isOpenNow = false,
    this.deliveryFee = 0.0,
    this.minimumOrder = 0.0,
    this.ratingAverage = 0.0,
    this.ratingCount = 0,
    this.status,
    this.isVerified = false,
    this.isFavorite = false,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
  });

  VendorProfile copyWith({
    String? storeName,
    String? storeNameEn,
    String? description,
    String? descriptionEn,
    String? logoUrl,
    String? coverUrl,
    String? phone,
    String? whatsappNumber,
    String? email,
    double? latitude,
    double? longitude,
    String? address,
    String? openTime,
    String? closeTime,
    double? deliveryFee,
    double? minimumOrder,
  }) {
    return VendorProfile(
      id: id,
      userId: userId,
      vendorCategoryId: vendorCategoryId,
      vendorCategoryName: vendorCategoryName,
      storeName: storeName ?? this.storeName,
      storeNameEn: storeNameEn ?? this.storeNameEn,
      description: description ?? this.description,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      logoUrl: logoUrl ?? this.logoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      phone: phone ?? this.phone,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      email: email ?? this.email,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      isOpenNow: isOpenNow,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      minimumOrder: minimumOrder ?? this.minimumOrder,
      ratingAverage: ratingAverage,
      ratingCount: ratingCount,
      status: status,
      isVerified: isVerified,
      isFavorite: isFavorite,
      rejectionReason: rejectionReason,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
