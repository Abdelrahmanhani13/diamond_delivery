import '../models/vendor_model.dart';
import 'package:diamond_customer/core/api/api_client.dart';
import 'package:diamond_customer/core/api/api_constants.dart';

abstract class StoresRemoteDataSource {
  Future<List<VendorModel>> getVendors({
    required int page,
    required int pageSize,
    String? search,
    String? categoryId,
    bool? openNow,
    double? rating,
    String? sortBy,
  });

  Future<List<VendorModel>> getNearbyVendors({
    required double latitude,
    required double longitude,
    required double radiusKm,
    required int page,
    required int pageSize,
  });

  Future<VendorModel> getVendorById(String id);
}

class StoresRemoteDataSourceImpl implements StoresRemoteDataSource {
  final ApiClient apiClient;

  StoresRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<VendorModel>> getVendors({
    required int page,
    required int pageSize,
    String? search,
    String? categoryId,
    bool? openNow,
    double? rating,
    String? sortBy,
  }) async {
    final endpoint = (search != null && search.isNotEmpty) 
        ? ApiConstants.searchVendors 
        : ApiConstants.vendors;
        
    final response = await apiClient.get(
      endpoint,
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        if (search != null && search.isNotEmpty) 'query': search, // assuming search endpoint might take 'query' or 'search'
        'categoryId': ?categoryId,
        'openNow': ?openNow,
        'rating': ?rating,
        'sortBy': ?sortBy,
      },
    );
    final responseData = response['data'] ?? response;
    final List<dynamic> data = (responseData is Map ? responseData['items'] : null) ?? (responseData as List? ?? []);
    return data.map((e) => VendorModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<VendorModel>> getNearbyVendors({
    required double latitude,
    required double longitude,
    required double radiusKm,
    required int page,
    required int pageSize,
  }) async {
    final response = await apiClient.get(
      ApiConstants.nearbyVendors,
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'radiusKm': radiusKm,
        'page': page,
        'pageSize': pageSize,
      },
    );
    final responseData = response['data'] ?? response;
    final List<dynamic> data = (responseData is Map ? responseData['items'] : null) ?? (responseData as List? ?? []);
    return data.map((e) => VendorModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<VendorModel> getVendorById(String id) async {
    final response = await apiClient.get('${ApiConstants.vendors}/$id');
    final responseData = response['data'] ?? response;
    return VendorModel.fromJson(responseData);
  }
}
