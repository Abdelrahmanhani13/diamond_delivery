// presentation/cubit/register/vendor_register_state.dart
import 'package:equatable/equatable.dart';

abstract class VendorRegisterState extends Equatable {
  const VendorRegisterState();

  @override
  List<Object?> get props => [];
}

class VendorRegisterInitial extends VendorRegisterState {}

class VendorRegisterLoading extends VendorRegisterState {}

class VendorRegisterSuccess extends VendorRegisterState {}

class VendorRegisterFailure extends VendorRegisterState {
  final String message;
  const VendorRegisterFailure(this.message);

  @override
  List<Object?> get props => [message];
}
