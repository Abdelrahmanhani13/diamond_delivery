// data/datasources/vendor_product_remote_data_source.dart
import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/api/vendor_api_constants.dart';
import '../models/vendor_product_model.dart';
import '../models/vendor_product_list_item_model.dart';
import '../models/vendor_product_image_model.dart';
import '../models/vendor_product_request_model.dart';
import 'package:vendor_dashboard/core/api/api_client.dart';
import 'package:vendor_dashboard/core/api/vendor_api_constants.dart';

abstract class VendorProductRemoteDataSource {
  Future<VendorProductPageModel> getProducts({
    required int page,
    required int pageSize,
    String? subCategoryId,
  });

  Future<VendorProductModel> getProductById(String id);

  Future<VendorProductModel> createProduct(VendorProductRequestModel request);

  Future<VendorProductModel> updateProduct(
    String id,
    VendorProductRequestModel request,
  );

  Future<void> deleteProduct(String id);

  Future<VendorProductModel> changeAvailability({
    required String id,
    required bool isAvailable,
  });

  Future<VendorProductImageModel> uploadImage({
    required String productId,
    required File file,
  });

  Future<List<VendorProductImageModel>> getImages(String productId);

  Future<void> deleteImage({
    required String productId,
    required String imageId,
  });

  Future<void> setPrimaryImage({
    required String productId,
    required String imageId,
  });
}

class VendorProductRemoteDataSourceImpl
    implements VendorProductRemoteDataSource {
  final ApiClient apiClient;

  VendorProductRemoteDataSourceImpl(this.apiClient);

  @override
  Future<VendorProductPageModel> getProducts({
    required int page,
    required int pageSize,
    String? subCategoryId,
  }) async {
    final response = await apiClient.get(
      ApiConstants.vendorProducts,
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        if (subCategoryId != null && subCategoryId.isNotEmpty)
          'subCategoryId': subCategoryId,
      },
    );
    return VendorProductPageModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<VendorProductModel> getProductById(String id) async {
    final response = await apiClient.get(ApiConstants.vendorProductById(id));
    return VendorProductModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<VendorProductModel> createProduct(
    VendorProductRequestModel request,
  ) async {
    final response = await apiClient.post(
      ApiConstants.vendorProducts,
      data: request.toJson(),
    );
    return VendorProductModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<VendorProductModel> updateProduct(
    String id,
    VendorProductRequestModel request,
  ) async {
    // ملحوظة: السواجر مبيّنش الميثود بالحرف (بس فيه id في الـ path ونفس
    // الـ body بتاع الإنشاء) → مفترض PUT (استبدال كامل)، وده المتعارف
    // عليه REST-wise. لو فعليًا PATCH عندك قولّي أظبطها في ثانية.
    final response = await apiClient.put(
      ApiConstants.vendorProductById(id),
      data: request.toJson(),
    );
    return VendorProductModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<void> deleteProduct(String id) async {
    // ملحوظة: مفيش DELETE endpoint في السواجر اللي اتبعت لحد دلوقتي.
    // الافتراض هنا: DELETE /Vendor/products/{id} (نفس نمط الـ REST
    // الموجود). لو الـ endpoint الفعلي مختلف ابعتهولي وأظبطه بسرعة.
    await apiClient.delete(ApiConstants.vendorProductById(id));
  }

  @override
  Future<VendorProductModel> changeAvailability({
    required String id,
    required bool isAvailable,
  }) async {
    final response = await apiClient.patch(
      ApiConstants.vendorProductAvailability(id),
      data: {'isAvailable': isAvailable},
    );
    return VendorProductModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<VendorProductImageModel> uploadImage({
    required String productId,
    required File file,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
    });
    final response = await apiClient.post(
      ApiConstants.vendorProductImages(productId),
      data: formData,
    );
    final map = response as Map<String, dynamic>;
    return VendorProductImageModel.fromJson(
      map['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<List<VendorProductImageModel>> getImages(String productId) async {
    final response = await apiClient.get(
      ApiConstants.vendorProductImages(productId),
    );
    final map = response as Map<String, dynamic>;
    final data = map['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => VendorProductImageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> deleteImage({
    required String productId,
    required String imageId,
  }) async {
    await apiClient.delete(
      ApiConstants.vendorProductImageById(productId, imageId),
    );
  }

  @override
  Future<void> setPrimaryImage({
    required String productId,
    required String imageId,
  }) async {
    await apiClient.patch(
      ApiConstants.vendorProductImagePrimary(productId, imageId),
    );
  }
}
