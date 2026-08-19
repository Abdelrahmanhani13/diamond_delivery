import 'package:dartz/dartz.dart';
// presentation/cubit/otp/vendor_otp_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'vendor_otp_state.dart';
import 'package:vendor_dashboard/features/auth/domain/usecases/vendor_verify_otp_usecase.dart';
import 'package:vendor_dashboard/features/auth/domain/usecases/vendor_request_otp_usecase.dart';

class VendorOtpCubit extends Cubit<VendorOtpState> {
  final VendorRequestOtpUseCase requestOtpUseCase;
  final VendorVerifyOtpUseCase verifyOtpUseCase;

  VendorOtpCubit({
    required this.requestOtpUseCase,
    required this.verifyOtpUseCase,
  }) : super(VendorOtpInitial());

  Future<void> requestOtp({
    required String email,
    required String otpType,
  }) async {
    emit(VendorOtpLoading());

    final result = await requestOtpUseCase(email, otpType);

    result.fold(
      (failure) => emit(VendorOtpFailure(failure.errMessage)),
      (_) => emit(VendorOtpRequestSuccess()),
    );
  }

  Future<void> verifyOtp({
    required String email,
    required String code,
    required String otpType,
    required String deviceName,
  }) async {
    emit(VendorOtpLoading());

    final result = await verifyOtpUseCase(email, code, otpType, deviceName);

    result.fold(
      (failure) => emit(VendorOtpFailure(failure.errMessage)),
      (tokens) => emit(VendorOtpVerifySuccess()),
    );
  }
}
