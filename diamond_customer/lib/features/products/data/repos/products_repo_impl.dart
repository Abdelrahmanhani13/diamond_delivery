import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/product.dart';
import '../../domain/repos/products_repo.dart';
import '../datasource/products_remote_data_source.dart';
import 'package:diamond_customer/core/errors/exceptions.dart';
import 'package:diamond_customer/core/network/network_info.dart';

class ProductsRepoImpl implements ProductsRepo {
  final ProductsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductsRepoImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    required int page,
    required int pageSize,
    String? search,
    String? vendorCategoryId,
    String? subCategoryId,
    String? vendorId,
    double? minPrice,
    double? maxPrice,
    int? sortBy,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getProducts(
          page: page,
          pageSize: pageSize,
          search: search,
          vendorCategoryId: vendorCategoryId,
          subCategoryId: subCategoryId,
          vendorId: vendorId,
          minPrice: minPrice,
          maxPrice: maxPrice,
          sortBy: sortBy,
        );
        return Right(products);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, errors: e.errors));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final product = await remoteDataSource.getProductById(id);
        return Right(product);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, errors: e.errors));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getRelatedProducts(
    String productId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getRelatedProducts(productId);
        return Right(products);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, errors: e.errors));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }
}
