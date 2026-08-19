// domain/usecases/vendor_update_profile_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/vendor_profile.dart';
import '../repositories/vendor_profile_repository.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';

class VendorUpdateProfileUseCase {
  final VendorProfileRepository repository;

  VendorUpdateProfileUseCase(this.repository);

  Future<Either<Failure, VendorProfile>> call({
    required String storeName,
    String? storeNameEn,
    required String phone,
    required String address,
    required double latitude,
    required double longitude,
    String? description,
    String? descriptionEn,
    String? whatsappNumber,
    String? email,
    String? openTime,
    String? closeTime,
    required double deliveryFee,
    required double minimumOrder,
  }) {
    return repository.updateProfile(
      storeName: storeName,
      storeNameEn: storeNameEn,
      phone: phone,
      address: address,
      latitude: latitude,
      longitude: longitude,
      description: description,
      descriptionEn: descriptionEn,
      whatsappNumber: whatsappNumber,
      email: email,
      openTime: openTime,
      closeTime: closeTime,
      deliveryFee: deliveryFee,
      minimumOrder: minimumOrder,
    );
  }
}
