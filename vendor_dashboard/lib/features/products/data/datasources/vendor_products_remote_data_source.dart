import 'dart:io';
import 'package:dio/dio.dart';
import 'package:vendor_dashboard/core/api/api_client.dart';
import 'package:vendor_dashboard/core/api/api_constants.dart';
import '../models/vendor_product_model.dart';
import '../models/vendor_product_list_item_model.dart';
import '../models/vendor_product_image_model.dart';
import '../models/vendor_product_request_model.dart';

abstract class VendorProductRemoteDataSource {
  Future<VendorProductPageModel> getProducts({
    required int page,
    required int pageSize,
    String? subCategoryId,
    String? search,
    bool? isAvailable,
    int? sortBy,
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
    String? search,
    bool? isAvailable,
    int? sortBy,
  }) async {
    final query = <String, dynamic>{'page': page, 'pageSize': pageSize};
    if (subCategoryId != null && subCategoryId.isNotEmpty) {
      query['subCategoryId'] = subCategoryId;
    }
    if (search != null && search.isNotEmpty) {
      query['search'] = search;
    }
    if (isAvailable != null) {
      query['isAvailable'] = isAvailable;
    }
    if (sortBy != null) {
      query['sortBy'] = sortBy;
    }

    final response = await apiClient.get(
      ApiConstants.vendorProducts,
      queryParameters: query,
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
    final response = await apiClient.put(
      ApiConstants.vendorProductById(id),
      data: request.toJson(),
    );
    return VendorProductModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<void> deleteProduct(String id) async {
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
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split(Platform.pathSeparator).last,
      ),
    });
    final response = await apiClient.post(
      ApiConstants.vendorProductImages(productId),
      data: formData,
    );
    final map = response as Map<String, dynamic>;
    final data = map['data'] is Map<String, dynamic>
        ? map['data'] as Map<String, dynamic>
        : map;
    return VendorProductImageModel.fromJson(data);
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
