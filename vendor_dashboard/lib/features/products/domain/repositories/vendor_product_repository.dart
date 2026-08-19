// domain/repositories/vendor_product_repository.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/vendor_product.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';

abstract class VendorProductRepository {
  Future<Either<Failure, ({List<VendorProduct> products, bool hasNextPage})>>
  getProducts({
    required int page,
    required int pageSize,
    String? subCategoryId,
  });

  Future<Either<Failure, VendorProduct>> getProductById(String id);

  Future<Either<Failure, VendorProduct>> createProduct({
    required String subCategoryId,
    required String nameArabic,
    required String nameEnglish,
    String? descriptionArabic,
    String? descriptionEnglish,
    required double price,
    double? discountPrice,
    int stockQuantity,
    String? sku,
    String? barcode,
    double? weight,
  });

  Future<Either<Failure, VendorProduct>> updateProduct({
    required String id,
    required String subCategoryId,
    required String nameArabic,
    required String nameEnglish,
    String? descriptionArabic,
    String? descriptionEnglish,
    required double price,
    double? discountPrice,
    int stockQuantity,
    String? sku,
    String? barcode,
    double? weight,
  });

  /// ملحوظة: مفيش endpoint حذف منتج في السواجر اللي اتبعت. الـ repository
  /// مبني على افتراض DELETE /Vendor/products/{id} (نفس نمط الباقي).
  /// لو عندك endpoint مختلف ابعتهولي وأظبط الـ data source.
  Future<Either<Failure, void>> deleteProduct(String id);

  Future<Either<Failure, VendorProduct>> changeAvailability({
    required String id,
    required bool isAvailable,
  });

  Future<Either<Failure, VendorProductImage>> uploadImage({
    required String productId,
    required File file,
  });

  Future<Either<Failure, List<VendorProductImage>>> getImages(String productId);

  Future<Either<Failure, void>> deleteImage({
    required String productId,
    required String imageId,
  });

  Future<Either<Failure, void>> setPrimaryImage({
    required String productId,
    required String imageId,
  });
}
