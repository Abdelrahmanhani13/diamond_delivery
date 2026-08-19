import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/repos/home_repo.dart';
import '../datasource/home_remote_data_source.dart';
import 'package:diamond_customer/core/errors/exceptions.dart';
import 'package:diamond_customer/core/network/network_info.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  HomeRepoImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, HomeData>> getHomeData({
    required double latitude,
    required double longitude,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final homeData = await remoteDataSource.getHomeData(
          latitude: latitude,
          longitude: longitude,
        );
        return Right(homeData);
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
