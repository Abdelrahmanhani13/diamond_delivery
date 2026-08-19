// data/models/vendor_update_profile_request_model.dart

/// جسم الـ PUT /Vendor/profile بالظبط زي ما هو موصوف في الـ swagger.
class VendorUpdateProfileRequestModel {
  final String nameArabic;
  final String nameEnglish;
  final String phoneNumber;
  final String address;
  final double latitude;
  final double longitude;
  final String? descriptionArabic;
  final String? descriptionEnglish;
  final String? whatsappNumber;
  final String? email;
  final String? openTime;
  final String? closeTime;
  final double deliveryFee;
  final double minimumOrder;

  const VendorUpdateProfileRequestModel({
    required this.nameArabic,
    required this.nameEnglish,
    required this.phoneNumber,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.descriptionArabic,
    this.descriptionEnglish,
    this.whatsappNumber,
    this.email,
    this.openTime,
    this.closeTime,
    required this.deliveryFee,
    required this.minimumOrder,
  });

  Map<String, dynamic> toJson() {
    return {
      'nameArabic': nameArabic,
      'nameEnglish': nameEnglish,
      'phoneNumber': phoneNumber,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'descriptionArabic': descriptionArabic,
      'descriptionEnglish': descriptionEnglish,
      'whatsappNumber': whatsappNumber,
      'email': email,
      'openTime': openTime,
      'closeTime': closeTime,
      'deliveryFee': deliveryFee,
      'minimumOrder': minimumOrder,
    };
  }
}
