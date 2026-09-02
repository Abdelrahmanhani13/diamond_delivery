import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor_dashboard/features/products/domain/usecases/create_vendor_product_use_case.dart';
import 'package:vendor_dashboard/features/products/domain/usecases/delete_vendor_product_image_use_case.dart';
import 'package:vendor_dashboard/features/products/domain/usecases/set_primary_product_image_use_case.dart';
import 'package:vendor_dashboard/features/products/domain/usecases/update_vendor_product_use_case.dart';
import 'package:vendor_dashboard/features/products/domain/usecases/upload_vendor_product_image_use_case.dart';

import 'vendor_product_form_state.dart';

class VendorProductFormCubit extends Cubit<VendorProductFormState> {
  final CreateVendorProductUseCase createProductUseCase;
  final UpdateVendorProductUseCase updateProductUseCase;
  final UploadVendorProductImageUseCase uploadImageUseCase;
  final DeleteVendorProductImageUseCase deleteImageUseCase;
  final SetPrimaryVendorProductImageUseCase setPrimaryImageUseCase;

  VendorProductFormCubit({
    required this.createProductUseCase,
    required this.updateProductUseCase,
    required this.uploadImageUseCase,
    required this.deleteImageUseCase,
    required this.setPrimaryImageUseCase,
  }) : super(VendorProductFormInitial());

  Future<void> createProduct({
    required String subCategoryId,
    required String nameArabic,
    required String nameEnglish,
    String? descriptionArabic,
    String? descriptionEnglish,
    required double price,
    double? discountPrice,
    int stockQuantity = 0,
    String? sku,
    String? barcode,
    double? weight,
  }) async {
    emit(VendorProductFormLoading());

    final result = await createProductUseCase(
      subCategoryId: subCategoryId,
      nameArabic: nameArabic,
      nameEnglish: nameEnglish,
      descriptionArabic: descriptionArabic,
      descriptionEnglish: descriptionEnglish,
      price: price,
      discountPrice: discountPrice,
      stockQuantity: stockQuantity,
      sku: sku,
      barcode: barcode,
      weight: weight,
    );

    result.fold(
      (failure) => emit(VendorProductFormError(failure.errMessage)),
      (product) => emit(VendorProductFormSuccess(product)),
    );
  }

  Future<void> addProduct({
    required String subCategoryId,
    required String nameArabic,
    required String nameEnglish,
    String? descriptionArabic,
    String? descriptionEnglish,
    required double price,
    double? discountPrice,
    int stockQuantity = 0,
    String? sku,
    String? barcode,
    double? weight,
  }) => createProduct(
    subCategoryId: subCategoryId,
    nameArabic: nameArabic,
    nameEnglish: nameEnglish,
    descriptionArabic: descriptionArabic,
    descriptionEnglish: descriptionEnglish,
    price: price,
    discountPrice: discountPrice,
    stockQuantity: stockQuantity,
    sku: sku,
    barcode: barcode,
    weight: weight,
  );

  Future<void> updateProduct({
    required String id,
    required String subCategoryId,
    required String nameArabic,
    required String nameEnglish,
    String? descriptionArabic,
    String? descriptionEnglish,
    required double price,
    double? discountPrice,
    int stockQuantity = 0,
    String? sku,
    String? barcode,
    double? weight,
  }) async {
    emit(VendorProductFormLoading());

    final result = await updateProductUseCase(
      id: id,
      subCategoryId: subCategoryId,
      nameArabic: nameArabic,
      nameEnglish: nameEnglish,
      descriptionArabic: descriptionArabic,
      descriptionEnglish: descriptionEnglish,
      price: price,
      discountPrice: discountPrice,
      stockQuantity: stockQuantity,
      sku: sku,
      barcode: barcode,
      weight: weight,
    );

    result.fold(
      (failure) => emit(VendorProductFormError(failure.errMessage)),
      (product) => emit(VendorProductFormSuccess(product)),
    );
  }

  Future<void> uploadImage({
    required String productId,
    required File imageFile,
  }) async {
    emit(VendorProductImageUploading());

    final result = await uploadImageUseCase(
      productId: productId,
      file: imageFile,
    );

    result.fold(
      (failure) => emit(VendorProductFormError(failure.errMessage)),
      (image) => emit(VendorProductImageUploaded(image)),
    );
  }

  Future<void> deleteImage({
    required String productId,
    required String imageId,
  }) async {
    final result = await deleteImageUseCase(
      productId: productId,
      imageId: imageId,
    );

    result.fold(
      (failure) => emit(VendorProductFormError(failure.errMessage)),
      (_) => emit(VendorProductImageDeleted()),
    );
  }

  Future<void> setPrimaryImage({
    required String productId,
    required String imageId,
  }) async {
    final result = await setPrimaryImageUseCase(
      productId: productId,
      imageId: imageId,
    );

    result.fold(
      (failure) => emit(VendorProductFormError(failure.errMessage)),
      (_) => emit(VendorProductPrimaryImageSet()),
    );
  }
}
