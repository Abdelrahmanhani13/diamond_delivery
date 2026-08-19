import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../products/domain/entities/product.dart';
import '../../../stores/domain/entities/vendor.dart';
import '../../domain/entities/search_data.dart';
import '../../domain/repos/search_repo.dart';
import '../datasource/search_remote_data_source.dart';
import 'package:diamond_customer/core/errors/exceptions.dart';
import 'package:diamond_customer/core/network/network_info.dart';

class SearchRepoImpl implements SearchRepo {
  final SearchRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SearchRepoImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, SearchData>> search(String query) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }

    List<Product> products = const [];
    List<Vendor> vendors = const [];
    Object? lastError;

    try {
      final result = await remoteDataSource.search(query);
      products = result.products;
      vendors = result.vendors;
    } catch (e) {
      lastError = e;
    }

    if (products.isEmpty && vendors.isEmpty && lastError != null) {
      final error = lastError;
      if (error is ServerException) {
        return Left(
          ServerFailure(message: error.message, errors: error.errors),
        );
      }
      return Left(ServerFailure(message: error.toString()));
    }

    return Right(SearchData(products: products, vendors: vendors));
  }
}
