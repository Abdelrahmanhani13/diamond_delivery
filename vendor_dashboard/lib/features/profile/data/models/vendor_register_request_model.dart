class VendorRegisterRequestModel {
  final String vendorCategoryId;
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
  final double deliveryFee;
  final double minimumOrder;

  const VendorRegisterRequestModel({
    required this.vendorCategoryId,
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
    required this.deliveryFee,
    required this.minimumOrder,
  });

  Map<String, dynamic> toJson() {
    return {
      'vendorCategoryId': vendorCategoryId,
      'nameArabic': nameArabic,
      'nameEnglish': nameEnglish,
      'phoneNumber': phoneNumber,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      if (descriptionArabic != null) 'descriptionArabic': descriptionArabic,
      if (descriptionEnglish != null) 'descriptionEnglish': descriptionEnglish,
      if (whatsappNumber != null) 'whatsappNumber': whatsappNumber,
      if (email != null) 'email': email,
      'deliveryFee': deliveryFee,
      'minimumOrder': minimumOrder,
    };
  }
}
