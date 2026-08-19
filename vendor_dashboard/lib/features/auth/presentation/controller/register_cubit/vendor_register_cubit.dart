import 'package:dartz/dartz.dart';
// presentation/cubit/register/vendor_register_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor_dashboard/features/profile/domain/usecases/vendor_register_usecase.dart';
import 'vendor_register_state.dart';

class VendorRegisterCubit extends Cubit<VendorRegisterState> {
  final VendorRegisterUseCase registerUseCase;

  VendorRegisterCubit({required this.registerUseCase})
    : super(VendorRegisterInitial());

  Future<void> register({
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
    emit(VendorRegisterLoading());

    final result = await registerUseCase(
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
    );

    result.fold(
      (failure) => emit(VendorRegisterFailure(failure.errMessage)),
      (_) => emit(VendorRegisterSuccess()),
    );
  }
}
