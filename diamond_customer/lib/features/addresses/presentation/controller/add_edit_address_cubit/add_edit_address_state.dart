import 'package:diamond_customer/features/addresses/domain/entities/address_domain_entity.dart';
import 'package:equatable/equatable.dart';

abstract class AddEditAddressState extends Equatable {
  const AddEditAddressState();

  @override
  List<Object?> get props => [];
}

class AddEditAddressInitial extends AddEditAddressState {}

class AddEditAddressLoading extends AddEditAddressState {}

class AddEditAddressSuccess extends AddEditAddressState {
  final Address address;

  const AddEditAddressSuccess(this.address);

  @override
  List<Object?> get props => [address];
}

class AddEditAddressError extends AddEditAddressState {
  final String message;

  const AddEditAddressError(this.message);

  @override
  List<Object?> get props => [message];
}
