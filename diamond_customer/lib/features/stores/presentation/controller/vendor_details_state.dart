import 'package:equatable/equatable.dart';
import '../../domain/entities/vendor.dart';

abstract class VendorDetailsState extends Equatable {
  const VendorDetailsState();

  @override
  List<Object?> get props => [];
}

class VendorDetailsInitial extends VendorDetailsState {}

class VendorDetailsLoading extends VendorDetailsState {}

class VendorDetailsLoaded extends VendorDetailsState {
  final Vendor vendor;

  const VendorDetailsLoaded(this.vendor);

  @override
  List<Object?> get props => [vendor];
}

class VendorDetailsError extends VendorDetailsState {
  final String message;

  const VendorDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
