import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/lookup_item.dart';
import '../../domain/repos/lookup_repository.dart';
import '../datasources/lookup_remote_data_source.dart';
import '../models/lookup_item_model.dart';
import 'package:diamond_customer/core/errors/exceptions.dart';
import 'package:diamond_customer/core/network/network_info.dart';

class LookupRepositoryImpl implements LookupRepository {
  final LookupRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  LookupRepositoryImpl({
    required LookupRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  Future<Either<Failure, List<LookupItem>>> _execute(
    Future<List<LookupItemModel>> Function() action,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final result = await action();
      return Right(result);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
          errors: e.errors,
        ),
      );
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<LookupItem>>> getCountries() {
    return _execute(() => _remoteDataSource.getCountries());
  }

  @override
  Future<Either<Failure, List<LookupItem>>> getGovernorates(String countryId) {
    return _execute(() => _remoteDataSource.getGovernorates(countryId));
  }

  @override
  Future<Either<Failure, List<LookupItem>>> getCities(String governorateId) {
    return _execute(() => _remoteDataSource.getCities(governorateId));
  }

  // مش موجود في الـ OpenAPI حالياً
  // @override
  // Future<Either<Failure, List<LookupItem>>> getAreas(String cityId) {
  //   return _execute(() => _remoteDataSource.getAreas(cityId));
  // }

  @override
  Future<Either<Failure, List<LookupItem>>> getAddressTypes() {
    return _execute(() => _remoteDataSource.getAddressTypes());
  }

  @override
  Future<Either<Failure, List<LookupItem>>> getGenders() {
    return _execute(() => _remoteDataSource.getGenders());
  }
}
