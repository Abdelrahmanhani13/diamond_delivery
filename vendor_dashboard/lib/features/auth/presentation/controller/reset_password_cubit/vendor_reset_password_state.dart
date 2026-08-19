// presentation/cubit/reset_password/vendor_reset_password_state.dart
import 'package:equatable/equatable.dart';

abstract class VendorResetPasswordState extends Equatable {
  const VendorResetPasswordState();

  @override
  List<Object?> get props => [];
}

class VendorResetPasswordInitial extends VendorResetPasswordState {}

class VendorResetPasswordLoading extends VendorResetPasswordState {}

class VendorResetPasswordSuccess extends VendorResetPasswordState {}

class VendorResetPasswordFailure extends VendorResetPasswordState {
  final String message;
  const VendorResetPasswordFailure(this.message);

  @override
  List<Object?> get props => [message];
}
