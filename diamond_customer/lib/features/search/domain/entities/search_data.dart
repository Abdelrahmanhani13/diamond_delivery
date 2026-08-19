import 'package:equatable/equatable.dart';
import '../../../products/domain/entities/product.dart';
import '../../../stores/domain/entities/vendor.dart';

class SearchData extends Equatable {
  final List<Product> products;
  final List<Vendor> vendors;

  const SearchData({
    required this.products,
    required this.vendors,
  });

  @override
  List<Object?> get props => [products, vendors];
}
