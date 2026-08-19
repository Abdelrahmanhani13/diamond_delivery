// presentation/cubit/auth/vendor_auth_state.dart
import 'package:equatable/equatable.dart';

abstract class VendorAuthState extends Equatable {
  const VendorAuthState();

  @override
  List<Object?> get props => [];
}

class VendorAuthInitial extends VendorAuthState {}

class VendorAuthenticated extends VendorAuthState {}

class VendorUnauthenticated extends VendorAuthState {}
