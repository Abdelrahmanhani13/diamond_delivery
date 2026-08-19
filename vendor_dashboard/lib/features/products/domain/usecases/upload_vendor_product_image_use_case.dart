// domain/usecases/upload_vendor_product_image_usecase.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/vendor_product.dart';
import '../repositories/vendor_product_repository.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';

class UploadVendorProductImageUseCase {
  final VendorProductRepository repository;
  UploadVendorProductImageUseCase(this.repository);

  Future<Either<Failure, VendorProductImage>> call({
    required String productId,
    required File file,
  }) {
    return repository.uploadImage(productId: productId, file: file);
  }
}
