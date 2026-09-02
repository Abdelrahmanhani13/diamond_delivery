import 'package:vendor_dashboard/core/api/api_client.dart';
import 'package:vendor_dashboard/core/api/api_constants.dart';
import '../models/vendor_category_model.dart';

abstract class VendorCategoriesRemoteDataSource {
  Future<List<VendorCategoryModel>> getVendorCategories();
}

class VendorCategoriesRemoteDataSourceImpl
    implements VendorCategoriesRemoteDataSource {
  final ApiClient apiClient;

  VendorCategoriesRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<VendorCategoryModel>> getVendorCategories() async {
    final response = await apiClient.get(ApiConstants.vendorCategories);
    final map = response as Map<String, dynamic>;
    final data = map['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => VendorCategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
