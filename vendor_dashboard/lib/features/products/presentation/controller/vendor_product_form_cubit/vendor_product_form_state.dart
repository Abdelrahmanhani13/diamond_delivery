// presentation/controller/product_form_cubit/vendor_product_form_state.dart
import '../../../domain/entities/vendor_product.dart';

abstract class VendorProductFormState {}

class VendorProductFormInitial extends VendorProductFormState {}

class VendorProductFormLoading extends VendorProductFormState {}

class VendorProductFormSuccess extends VendorProductFormState {
  final VendorProduct product;
  VendorProductFormSuccess(this.product);
}

class VendorProductFormError extends VendorProductFormState {
  final String message;
  VendorProductFormError(this.message);
}

class VendorProductImageUploading extends VendorProductFormState {}

class VendorProductImageUploaded extends VendorProductFormState {
  final VendorProductImage image;
  VendorProductImageUploaded(this.image);
}

class VendorProductImageDeleted extends VendorProductFormState {}

class VendorProductPrimaryImageSet extends VendorProductFormState {}
