// data/repositories/vendor_product_repository_impl.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/features/products/data/datasources/vendor_products_remote_data_source.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/vendor_product.dart';
import '../../domain/repositories/vendor_product_repository.dart';
import '../models/vendor_product_request_model.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import 'package:vendor_dashboard/core/errors/exceptions.dart';

class VendorProductRepositoryImpl implements VendorProductRepository {
  final VendorProductRemoteDataSource remoteDataSource;

  VendorProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ({List<VendorProduct> products, bool hasNextPage})>>
  getProducts({
    required int page,
    required int pageSize,
    String? subCategoryId,
  }) async {
    try {
      final result = await remoteDataSource.getProducts(
        page: page,
        pageSize: pageSize,
        subCategoryId: subCategoryId,
      );
      return Right((products: result.items, hasNextPage: result.hasNextPage));
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VendorProduct>> getProductById(String id) async {
    try {
      final result = await remoteDataSource.getProductById(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VendorProduct>> createProduct({
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
    try {
      final request = VendorProductRequestModel(
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
      final result = await remoteDataSource.createProduct(request);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VendorProduct>> updateProduct({
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
    try {
      final request = VendorProductRequestModel(
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
      final result = await remoteDataSource.updateProduct(id, request);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await remoteDataSource.deleteProduct(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VendorProduct>> changeAvailability({
    required String id,
    required bool isAvailable,
  }) async {
    try {
      final result = await remoteDataSource.changeAvailability(
        id: id,
        isAvailable: isAvailable,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VendorProductImage>> uploadImage({
    required String productId,
    required File file,
  }) async {
    try {
      final result = await remoteDataSource.uploadImage(
        productId: productId,
        file: file,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VendorProductImage>>> getImages(
    String productId,
  ) async {
    try {
      final result = await remoteDataSource.getImages(productId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteImage({
    required String productId,
    required String imageId,
  }) async {
    try {
      await remoteDataSource.deleteImage(
        productId: productId,
        imageId: imageId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setPrimaryImage({
    required String productId,
    required String imageId,
  }) async {
    try {
      await remoteDataSource.setPrimaryImage(
        productId: productId,
        imageId: imageId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
