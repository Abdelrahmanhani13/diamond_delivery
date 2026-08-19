// presentation/cubit/otp/vendor_otp_state.dart
import 'package:equatable/equatable.dart';

abstract class VendorOtpState extends Equatable {
  const VendorOtpState();

  @override
  List<Object?> get props => [];
}

class VendorOtpInitial extends VendorOtpState {}

class VendorOtpLoading extends VendorOtpState {}

class VendorOtpRequestSuccess extends VendorOtpState {}

class VendorOtpVerifySuccess extends VendorOtpState {}

class VendorOtpFailure extends VendorOtpState {
  final String message;
  const VendorOtpFailure(this.message);

  @override
  List<Object?> get props => [message];
}
