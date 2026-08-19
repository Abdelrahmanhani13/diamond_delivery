import '../models/search_data_model.dart';
import '../../../products/data/models/product_model.dart';
import '../../../stores/data/models/vendor_model.dart';
import 'package:diamond_customer/core/api/api_client.dart';
import 'package:diamond_customer/core/api/api_constants.dart';

abstract class SearchRemoteDataSource {
  Future<SearchDataModel> search(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiClient apiClient;

  SearchRemoteDataSourceImpl(this.apiClient);

  @override
  Future<SearchDataModel> search(String query) async {
    // Search Vendors
    final vendorsRes = await apiClient.get(
      ApiConstants.searchVendors,
      queryParameters: {'searchTerm': query},
    ).catchError((_) => {});
    final vData = vendorsRes['data'] ?? vendorsRes;
    final List<dynamic> vItems = (vData is Map ? vData['items'] : null) ?? (vData as List? ?? []);
    final vendors = vItems.map((e) => VendorModel.fromJson(e as Map<String, dynamic>)).toList();

    // Search Products
    final productsRes = await apiClient.get(
      ApiConstants.products,
      queryParameters: {'searchTerm': query},
    ).catchError((_) => {});
    final pData = productsRes['data'] ?? productsRes;
    final List<dynamic> pItems = (pData is Map ? pData['items'] : null) ?? (pData as List? ?? []);
    final products = pItems.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();

    return SearchDataModel(
      products: products,
      vendors: vendors,
    );
  }
}
