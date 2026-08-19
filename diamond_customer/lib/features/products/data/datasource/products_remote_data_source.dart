import '../models/product_model.dart';
import 'package:diamond_customer/core/api/api_client.dart';
import 'package:diamond_customer/core/api/api_constants.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    required int page,
    required int pageSize,
    String? search,
    String? vendorCategoryId,
    String? subCategoryId,
    String? vendorId,
    double? minPrice,
    double? maxPrice,
    int? sortBy, // ProductDiscoverySortBy (0,1,2,3,4)
  });

  Future<ProductModel> getProductById(String id);

  Future<List<ProductModel>> getRelatedProducts(String productId);
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final ApiClient apiClient;

  ProductsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ProductModel>> getProducts({
    required int page,
    required int pageSize,
    String? search,
    String? vendorCategoryId,
    String? subCategoryId,
    String? vendorId,
    double? minPrice,
    double? maxPrice,
    int? sortBy,
  }) async {
    final response = await apiClient.get(
      ApiConstants.products,
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        if (search != null && search.isNotEmpty) 'search': search,
        'vendorCategoryId': ?vendorCategoryId,
        'subCategoryId': ?subCategoryId,
        'vendorId': ?vendorId,
        'minPrice': ?minPrice,
        'maxPrice': ?maxPrice,
        'sortBy': ?sortBy,
      },
    );

    // الـ response شكله: { success, data: { items: [...], pageNumber, ... } }
    final pagedData = response['data'] as Map<String, dynamic>?;
    final List<dynamic> items = (pagedData?['items'] as List<dynamic>?) ?? [];

    return items
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final response = await apiClient.get(ApiConstants.productById(id));

    // الـ response شكله: { success, data: { ...product } }
    final data = response['data'] as Map<String, dynamic>;
    return ProductModel.fromJson(data);
  }

  @override
  Future<List<ProductModel>> getRelatedProducts(String productId) async {
    final response = await apiClient.get(
      ApiConstants.productRelated(productId),
    );

    // الـ response شكله: { success, data: [ ... ] }
    final List<dynamic> items = (response['data'] as List<dynamic>?) ?? [];

    return items
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
