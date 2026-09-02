import 'package:flutter_bloc/flutter_bloc.dart';
import 'vendor_reset_password_state.dart';
import 'package:vendor_dashboard/features/auth/domain/usecases/vendor_reset_password_usecase.dart';

class VendorResetPasswordCubit extends Cubit<VendorResetPasswordState> {
  final VendorResetPasswordUseCase resetPasswordUseCase;

  VendorResetPasswordCubit({required this.resetPasswordUseCase})
    : super(VendorResetPasswordInitial());

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    emit(VendorResetPasswordLoading());

    final result = await resetPasswordUseCase(email, code, newPassword);

    result.fold(
      (failure) => emit(VendorResetPasswordFailure(failure.errMessage)),
      (_) => emit(VendorResetPasswordSuccess()),
    );
  }
}
