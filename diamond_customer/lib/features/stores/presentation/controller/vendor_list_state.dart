import 'package:equatable/equatable.dart';
import '../../domain/entities/vendor.dart';

abstract class VendorListState extends Equatable {
  const VendorListState();

  @override
  List<Object?> get props => [];
}

class VendorListInitial extends VendorListState {}

class VendorListLoading extends VendorListState {}

class VendorListLoaded extends VendorListState {
  final List<Vendor> vendors;
  final bool hasReachedMax;

  const VendorListLoaded({
    required this.vendors,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [vendors, hasReachedMax];
}

class VendorListError extends VendorListState {
  final String message;

  const VendorListError(this.message);

  @override
  List<Object?> get props => [message];
}
