import '../../domain/entities/search_data.dart';
import '../../../products/data/models/product_model.dart';
import '../../../stores/data/models/vendor_model.dart';

class SearchDataModel extends SearchData {
  const SearchDataModel({
    required super.products,
    required super.vendors,
  });

  factory SearchDataModel.fromJson(Map<String, dynamic> json) {
    return SearchDataModel(
      products: (json['products'] as List<dynamic>?)
              ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      vendors: (json['vendors'] as List<dynamic>?)
              ?.map((e) => VendorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products': products.map((p) => (p as ProductModel).toJson()).toList(),
      'vendors': vendors.map((v) => (v as VendorModel).toJson()).toList(),
    };
  }
}
