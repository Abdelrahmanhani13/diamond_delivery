import '../models/home_data_model.dart';
import '../../../categories/data/models/category_model.dart';
import '../../../stores/data/models/vendor_model.dart';
import '../../../products/data/models/product_model.dart';
import 'package:diamond_customer/core/api/api_client.dart';
import 'package:diamond_customer/core/api/api_constants.dart';

abstract class HomeRemoteDataSource {
  Future<HomeDataModel> getHomeData({
    required double latitude,
    required double longitude,
  });
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSourceImpl(this.apiClient);

  @override
  Future<HomeDataModel> getHomeData({
    required double latitude,
    required double longitude,
  }) async {
    // 1. Categories
    final categoriesRes = await apiClient.get(ApiConstants.vendorCategories).catchError((_) => {});
    final catsData = categoriesRes['data'] ?? categoriesRes;
    final List<dynamic> catItems = (catsData is Map ? catsData['items'] : null) ?? (catsData as List? ?? []);
    final categories = catItems.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();

    // 2. Featured Vendors
    final vendorsRes = await apiClient.get(
      ApiConstants.vendors,
      queryParameters: {'pageSize': 5},
    ).catchError((_) => {});
    final vendData = vendorsRes['data'] ?? vendorsRes;
    final List<dynamic> vendItems = (vendData is Map ? vendData['items'] : null) ?? (vendData as List? ?? []);
    final featuredVendors = vendItems.map((e) => VendorModel.fromJson(e as Map<String, dynamic>)).toList();

    // 3. Nearby Vendors
    final nearbyRes = await apiClient.get(
      ApiConstants.nearbyVendors,
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'radiusKm': 10.0,
        'pageSize': 5,
      },
    ).catchError((_) => {});
    final nearData = nearbyRes['data'] ?? nearbyRes;
    final List<dynamic> nearItems = (nearData is Map ? nearData['items'] : null) ?? (nearData as List? ?? []);
    final nearbyVendors = nearItems.map((e) => VendorModel.fromJson(e as Map<String, dynamic>)).toList();

    // 4. Products
    final prodRes = await apiClient.get(
      ApiConstants.products,
      queryParameters: {'pageSize': 10},
    ).catchError((_) => {});
    final pData = prodRes['data'] ?? prodRes;
    final List<dynamic> pItems = (pData is Map ? pData['items'] : null) ?? (pData as List? ?? []);
    final latestProducts = pItems.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();

    return HomeDataModel(
      greeting: 'مرحباً بك',
      banners: const [],
      categories: categories,
      featuredVendors: featuredVendors,
      nearbyVendors: nearbyVendors,
      featuredProducts: latestProducts,
      latestProducts: latestProducts,
    );
  }
}
