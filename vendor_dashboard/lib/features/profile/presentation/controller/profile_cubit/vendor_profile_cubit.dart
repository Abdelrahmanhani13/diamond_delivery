// presentation/controller/profile_cubit/vendor_profile_cubit.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import 'package:vendor_dashboard/features/profile/domain/entities/vendor_profile.dart';
import 'package:vendor_dashboard/features/profile/domain/usecases/vendor_get_profile_use_case.dart';
import 'package:vendor_dashboard/features/profile/domain/usecases/vendor_update_profile_use_case.dart';
import 'package:vendor_dashboard/features/profile/domain/usecases/vendor_upload_cover_use_case.dart';
import 'package:vendor_dashboard/features/profile/domain/usecases/vendor_upload_logo_use_case.dart';

import 'vendor_profile_state.dart';

class VendorProfileCubit extends Cubit<VendorProfileState> {
  final VendorGetProfileUseCase getProfileUseCase;
  final VendorUpdateProfileUseCase updateProfileUseCase;
  final VendorUploadLogoUseCase uploadLogoUseCase;
  final VendorUploadCoverUseCase uploadCoverUseCase;

  /// بنحتفظ بآخر بروفايل اتحمّل عشان نقدر نكمّل بيه الحقول اللي شاشة
  /// التعديل مش بتديها (زي whatsapp, email, openTime..) وقت الـ PUT،
  /// لأن الـ endpoint بياخد الجسم كامل مش partial update.
  VendorProfile? _currentProfile;

  VendorProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.uploadLogoUseCase,
    required this.uploadCoverUseCase,
  }) : super(const VendorProfileInitial());

  Future<void> fetchProfile() async {
    emit(const VendorProfileLoading());
    final result = await getProfileUseCase();
    result.fold((failure) => emit(VendorProfileError(failure.errMessage)), (
      profile,
    ) {
      _currentProfile = profile;
      emit(VendorProfileLoaded(profile));
    });
  }

  Future<void> updateProfile({
    required String storeName,
    required String phone,
    required String description,
    required String address,
    File? logoFile,
    File? coverFile,
  }) async {
    emit(const VendorProfileUpdating());

    final base = _currentProfile;

    final updateResult = await updateProfileUseCase(
      storeName: storeName,
      storeNameEn: base?.storeNameEn,
      phone: phone,
      address: address,
      latitude: base?.latitude ?? 0.0,
      longitude: base?.longitude ?? 0.0,
      description: description,
      descriptionEn: base?.descriptionEn,
      whatsappNumber: base?.whatsappNumber,
      email: base?.email,
      openTime: base?.openTime,
      closeTime: base?.closeTime,
      deliveryFee: base?.deliveryFee ?? 0.0,
      minimumOrder: base?.minimumOrder ?? 0.0,
    );

    if (updateResult.isLeft()) {
      final failure = updateResult.fold((l) => l, (r) => null)!;
      emit(VendorProfileUpdateError(failure.errMessage));
      return;
    }

    var latestProfile = updateResult.fold(
      (l) => throw StateError('unreachable'),
      (profile) => profile,
    );

    if (logoFile != null) {
      final logoResult = await uploadLogoUseCase(logoFile);
      final logoOrError = _applyUploadResult(
        logoResult,
        (url) => latestProfile.copyWith(logoUrl: url),
      );
      if (logoOrError.isLeft()) {
        final failure = logoOrError.fold((l) => l, (r) => null)!;
        emit(VendorProfileUpdateError(failure.errMessage));
        return;
      }
      latestProfile = logoOrError.fold(
        (l) => throw StateError('unreachable'),
        (profile) => profile,
      );
    }

    if (coverFile != null) {
      final coverResult = await uploadCoverUseCase(coverFile);
      final coverOrError = _applyUploadResult(
        coverResult,
        (url) => latestProfile.copyWith(coverUrl: url),
      );
      if (coverOrError.isLeft()) {
        final failure = coverOrError.fold((l) => l, (r) => null)!;
        emit(VendorProfileUpdateError(failure.errMessage));
        return;
      }
      latestProfile = coverOrError.fold(
        (l) => throw StateError('unreachable'),
        (profile) => profile,
      );
    }

    _currentProfile = latestProfile;
    emit(VendorProfileUpdateSuccess(latestProfile));
  }

  Either<Failure, VendorProfile> _applyUploadResult(
    Either<Failure, String> uploadResult,
    VendorProfile Function(String url) apply,
  ) {
    return uploadResult.fold(
      (failure) => Left(failure),
      (url) => Right(apply(url)),
    );
  }
}
