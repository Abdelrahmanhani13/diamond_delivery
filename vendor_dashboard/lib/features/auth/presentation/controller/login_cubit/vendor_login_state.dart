// presentation/cubit/login/vendor_login_state.dart
import 'package:equatable/equatable.dart';

abstract class VendorLoginState extends Equatable {
  const VendorLoginState();

  @override
  List<Object?> get props => [];
}

class VendorLoginInitial extends VendorLoginState {}

class VendorLoginLoading extends VendorLoginState {}

class VendorLoginSuccess extends VendorLoginState {}

class VendorLoginFailure extends VendorLoginState {
  final String message;
  const VendorLoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}
