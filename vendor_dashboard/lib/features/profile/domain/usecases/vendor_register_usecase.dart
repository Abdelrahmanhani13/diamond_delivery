import 'package:dartz/dartz.dart';
import '../repositories/vendor_profile_repository.dart';
import '../../data/models/vendor_register_request_model.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';

class VendorRegisterUseCase {
  final VendorProfileRepository repository;

  VendorRegisterUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String vendorCategoryId,
    required String nameArabic,
    required String nameEnglish,
    required String phoneNumber,
    required String address,
    required double latitude,
    required double longitude,
    String? descriptionArabic,
    String? descriptionEnglish,
    String? whatsappNumber,
    String? email,
    required double deliveryFee,
    required double minimumOrder,
  }) async {
    return await repository.registerVendor(
      VendorRegisterRequestModel(
        vendorCategoryId: vendorCategoryId,
        nameArabic: nameArabic,
        nameEnglish: nameEnglish,
        phoneNumber: phoneNumber,
        address: address,
        latitude: latitude,
        longitude: longitude,
        descriptionArabic: descriptionArabic,
        descriptionEnglish: descriptionEnglish,
        whatsappNumber: whatsappNumber,
        email: email,
        deliveryFee: deliveryFee,
        minimumOrder: minimumOrder,
      ),
    );
  }
}
