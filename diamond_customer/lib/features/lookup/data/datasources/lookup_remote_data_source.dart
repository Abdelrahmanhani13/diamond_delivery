import '../../../../core/api/api_response.dart';
import '../models/lookup_item_model.dart';
import 'package:diamond_customer/core/api/api_client.dart';
import 'package:diamond_customer/core/api/api_constants.dart';

abstract class LookupRemoteDataSource {
  Future<List<LookupItemModel>> getCountries();
  Future<List<LookupItemModel>> getGovernorates(String countryId);
  Future<List<LookupItemModel>> getCities(String governorateId);
  // Future<List<LookupItemModel>> getAreas(String cityId); // مش موجود في الـ API
  Future<List<LookupItemModel>> getAddressTypes();
  Future<List<LookupItemModel>> getGenders();
}

class LookupRemoteDataSourceImpl implements LookupRemoteDataSource {
  final ApiClient _apiClient;

  // In-Memory Cache
  final Map<String, List<LookupItemModel>> _cache = {};

  LookupRemoteDataSourceImpl(this._apiClient);

  Future<List<LookupItemModel>> _fetchWithCache(String endpoint) async {
    if (_cache.containsKey(endpoint)) {
      return _cache[endpoint]!;
    }

    final response = await _apiClient.get(endpoint);

    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response,
      (json) => json as List<dynamic>,
    );

    final items =
        apiResponse.data
            ?.map((e) => LookupItemModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    _cache[endpoint] = items;
    return items;
  }

  @override
  Future<List<LookupItemModel>> getCountries() {
    return _fetchWithCache(ApiConstants.lookupCountries);
  }

  @override
  Future<List<LookupItemModel>> getGovernorates(String countryId) {
    return _fetchWithCache(ApiConstants.lookupGovernorates(countryId));
  }

  @override
  Future<List<LookupItemModel>> getCities(String governorateId) {
    return _fetchWithCache(ApiConstants.lookupCities(governorateId));
  }

  // مش موجود في الـ OpenAPI حالياً
  // @override
  // Future<List<LookupItemModel>> getAreas(String cityId) async {
  //   return [];
  // }

  @override
  Future<List<LookupItemModel>> getAddressTypes() {
    return _fetchWithCache(ApiConstants.lookupAddressTypes);
  }

  @override
  Future<List<LookupItemModel>> getGenders() {
    return _fetchWithCache(ApiConstants.lookupGenders);
  }
}
