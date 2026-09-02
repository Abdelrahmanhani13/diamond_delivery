import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import 'package:vendor_dashboard/features/profile/data/models/vendor_update_profile_request_model.dart';
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

  VendorProfile? _currentProfile;
  VendorProfile? get currentProfile => _currentProfile;

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

  Future<void> toggleOpenStatus(bool isOpen) async {
    final current = state;
    if (current is! VendorProfileLoaded) return;

    emit(current.copyWith(isUpdatingStatus: true));
    final updatedProfile = current.profile.copyWith(isOpenNow: isOpen);

    final request = VendorUpdateProfileRequestModel(
      nameArabic: updatedProfile.nameArabic,
      nameEnglish: updatedProfile.nameEnglish,
      phoneNumber: updatedProfile.phoneNumber,
      address: updatedProfile.addressText,
      latitude: updatedProfile.latitude,
      longitude: updatedProfile.longitude,
      deliveryFee: updatedProfile.deliveryFee,
      minimumOrder: updatedProfile.minimumOrder,
    );

    final result = await updateProfileUseCase(request);
    result.fold(
      (failure) {
        emit(current.copyWith(isUpdatingStatus: false));
      },
      (profile) {
        _currentProfile = profile;
        emit(VendorProfileLoaded(profile, stats: current.stats));
      },
    );
  }

  Future<void> uploadLogo(File logoFile) async {
    final current = state;
    if (current is! VendorProfileLoaded) return;

    final result = await uploadLogoUseCase(logoFile);
    result.fold((_) {}, (url) {
      final updated = current.profile.copyWith(logoUrl: url);
      _currentProfile = updated;
      emit(current.copyWith(profile: updated));
    });
  }

  Future<void> uploadCover(File coverFile) async {
    final current = state;
    if (current is! VendorProfileLoaded) return;

    final result = await uploadCoverUseCase(coverFile);
    result.fold((_) {}, (url) {
      final updated = current.profile.copyWith(coverUrl: url);
      _currentProfile = updated;
      emit(current.copyWith(profile: updated));
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

    final request = VendorUpdateProfileRequestModel(
      nameArabic: storeName,
      nameEnglish: base?.storeNameEn ?? storeName,
      phoneNumber: phone,
      address: address,
      latitude: base?.latitude ?? 0.0,
      longitude: base?.longitude ?? 0.0,
      descriptionArabic: description,
      descriptionEnglish: base?.descriptionEn,
      whatsappNumber: base?.whatsappNumber,
      email: base?.email,
      openTime: base?.openTime,
      closeTime: base?.closeTime,
      deliveryFee: base?.deliveryFee ?? 0.0,
      minimumOrder: base?.minimumOrder ?? 0.0,
    );

    final updateResult = await updateProfileUseCase(request);

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
