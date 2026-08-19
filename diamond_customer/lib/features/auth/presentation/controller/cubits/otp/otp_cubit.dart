import 'package:flutter_bloc/flutter_bloc.dart';
import 'otp_state.dart';
import 'package:diamond_customer/features/auth/domain/usecases/request_otp_use_case.dart';
import 'package:diamond_customer/features/auth/domain/usecases/verify_otp_use_case.dart';

class OtpCubit extends Cubit<OtpState> {
  final VerifyOtpUseCase _verifyOtpUseCase;
  final RequestOtpUseCase _requestOtpUseCase;

  OtpCubit(this._verifyOtpUseCase, this._requestOtpUseCase)
    : super(OtpInitial());

  Future<void> verifyOtp(String phoneNumber, String code, String otpType) async {
    emit(OtpLoading());
    final result = await _verifyOtpUseCase(phoneNumber, code, otpType, "Flutter App");
    result.fold(
      (failure) => emit(OtpError(failure.message)),
      (_) => emit(OtpSuccess()),
    );
  }

  Future<void> requestOtp(String phoneNumber, String otpType) async {
    final result = await _requestOtpUseCase(phoneNumber, otpType);
    result.fold(
      (failure) => emit(OtpError(failure.message)),
      (_) => emit(OtpResentSuccess()),
    );
  }
}
