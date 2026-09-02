import 'package:equatable/equatable.dart';
import '../../../../profile/domain/entities/vendor_category.dart';

abstract class VendorCategoriesState extends Equatable {
  const VendorCategoriesState();

  @override
  List<Object?> get props => [];
}

class VendorCategoriesInitial extends VendorCategoriesState {}

class VendorCategoriesLoading extends VendorCategoriesState {}

class VendorCategoriesLoaded extends VendorCategoriesState {
  final List<VendorCategory> categories;

  const VendorCategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class VendorCategoriesError extends VendorCategoriesState {
  final String message;

  const VendorCategoriesError(this.message);

  @override
  List<Object?> get props => [message];
}
