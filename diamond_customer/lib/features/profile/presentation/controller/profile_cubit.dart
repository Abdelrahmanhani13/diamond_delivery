import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diamond_customer/core/di/service_locator.dart';
import 'package:diamond_customer/features/orders/domain/usecases/orders_use_cases.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_profile_use_case.dart';
import '../../domain/usecases/update_profile_use_case.dart';
import '../../data/models/update_profile_request_model.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileCubit(this._getProfileUseCase, this._updateProfileUseCase)
      : super(ProfileInitial());

  Future<void> fetchProfile() async {
    emit(ProfileLoading());
    final result = await _getProfileUseCase();
    
    await result.fold(
      (failure) async {
        emit(ProfileError(
          failure.message,
          errors: failure is ServerFailure ? failure.errors : null,
        ));
      },
      (profile) async {
        int ordersCount = profile.completedOrdersCount;
        
        // Optionally fetch real order count from GetOrdersUseCase
        if (getIt.isRegistered<GetOrdersUseCase>()) {
          final ordersResult = await getIt<GetOrdersUseCase>()(page: 1, pageSize: 1);
          ordersResult.fold(
            (_) {},
            (ordersPage) {
              ordersCount = ordersPage.totalCount;
            },
          );
        }

        final updatedProfile = profile.copyWith(
          completedOrdersCount: ordersCount,
        );

        emit(ProfileLoaded(updatedProfile));
      },
    );
  }

  Future<void> updateProfile(UpdateProfileRequestModel request) async {
    emit(ProfileUpdateLoading());
    final result = await _updateProfileUseCase(request);
    result.fold(
      (failure) => emit(ProfileUpdateError(
        failure.message,
        errors: failure is ServerFailure ? failure.errors : null,
      )),
      (profile) => emit(ProfileUpdateSuccess(profile)),
    );
  }
}
