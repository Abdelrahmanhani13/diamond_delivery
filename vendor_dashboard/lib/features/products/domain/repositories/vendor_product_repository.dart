import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../entities/vendor_product.dart';

abstract class VendorProductRepository {
  Future<Either<Failure, ({List<VendorProduct> products, bool hasNextPage})>>
  getProducts({
    required int page,
    required int pageSize,
    String? subCategoryId,
    String? search,
    bool? isAvailable,
    int? sortBy,
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
