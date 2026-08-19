import '../../../stores/data/models/vendor_model.dart';
import '../../../products/data/models/product_model.dart';
import 'package:diamond_customer/core/api/api_client.dart';
import 'package:diamond_customer/core/api/api_constants.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<VendorModel>> getFavoriteVendors({
    required int page,
    required int pageSize,
    String? searchTerm,
    String? sortBy,
    bool? sortDescending,
  });

  Future<List<ProductModel>> getFavoriteProducts({
    required int page,
    required int pageSize,
    String? searchTerm,
    String? sortBy,
    bool? sortDescending,
  });

  Future<void> addFavoriteVendor(String vendorId);

  Future<void> removeFavoriteVendor(String vendorId);

  Future<void> addFavoriteProduct(String productId);

  Future<void> removeFavoriteProduct(String productId);
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final ApiClient apiClient;

  FavoritesRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<VendorModel>> getFavoriteVendors({
    required int page,
    required int pageSize,
    String? searchTerm,
    String? sortBy,
    bool? sortDescending,
  }) async {
    final response = await apiClient.get(
      ApiConstants.favoriteVendors,
      queryParameters: {
        'PageNumber': page,
        'PageSize': pageSize,
        'SearchTerm': ?searchTerm,
        'SortBy': ?sortBy,
        'SortDescending': ?sortDescending,
      },
    );

    // نحاول نقرأ data.items أو data مباشرة
    final data = response['data'];
    final List<dynamic> items = data is Map
        ? (data['items'] as List<dynamic>? ?? [])
        : (data as List<dynamic>? ?? []);

    return items
        .map((e) => VendorModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ProductModel>> getFavoriteProducts({
    required int page,
    required int pageSize,
    String? searchTerm,
    String? sortBy,
    bool? sortDescending,
  }) async {
    final response = await apiClient.get(
      ApiConstants.favoriteProducts,
      queryParameters: {
        'PageNumber': page,
        'PageSize': pageSize,
        'SearchTerm': ?searchTerm,
        'SortBy': ?sortBy,
        'SortDescending': ?sortDescending,
      },
    );

    final data = response['data'];
    final List<dynamic> items = data is Map
        ? (data['items'] as List<dynamic>? ?? [])
        : (data as List<dynamic>? ?? []);

    return items
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addFavoriteVendor(String vendorId) async {
    await apiClient.post(ApiConstants.favoriteVendorById(vendorId));
  }

  @override
  Future<void> removeFavoriteVendor(String vendorId) async {
    await apiClient.delete(ApiConstants.favoriteVendorById(vendorId));
  }

  @override
  Future<void> addFavoriteProduct(String productId) async {
    await apiClient.post(ApiConstants.favoriteProductById(productId));
  }

  @override
  Future<void> removeFavoriteProduct(String productId) async {
    await apiClient.delete(ApiConstants.favoriteProductById(productId));
  }
}
