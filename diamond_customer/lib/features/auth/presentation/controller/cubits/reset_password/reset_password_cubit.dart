import 'package:flutter_bloc/flutter_bloc.dart';
import 'reset_password_state.dart';
import 'package:diamond_customer/features/auth/domain/usecases/reset_password_use_case.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordUseCase _resetPasswordUseCase;

  ResetPasswordCubit(this._resetPasswordUseCase)
    : super(ResetPasswordInitial());

  Future<void> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    emit(ResetPasswordLoading());
    final result = await _resetPasswordUseCase(email, otp, newPassword);
    result.fold(
      (failure) => emit(ResetPasswordError(failure.message, errors: failure.errors)),
      (_) => emit(ResetPasswordSuccess()),
    );
  }
}
