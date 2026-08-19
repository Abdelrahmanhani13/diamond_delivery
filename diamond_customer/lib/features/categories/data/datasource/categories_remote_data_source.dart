import '../models/category_model.dart';
import 'package:diamond_customer/core/api/api_client.dart';
import 'package:diamond_customer/core/api/api_constants.dart';

abstract class CategoriesRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final ApiClient _apiClient;

  CategoriesRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiClient.get(ApiConstants.vendorCategories);
    final data = response['data'] ?? response;
    final List<dynamic> items = (data is Map ? data['items'] : null) ?? (data as List? ?? []);
    return items.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
