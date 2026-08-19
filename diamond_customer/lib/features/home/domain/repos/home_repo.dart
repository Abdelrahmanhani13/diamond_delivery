import '../../../../core/utils/either.dart';
import '../../../../core/errors/failures.dart';
import '../entities/home_data.dart';

abstract class HomeRepo {
  Future<Either<Failure, HomeData>> getHomeData({
    required double latitude,
    required double longitude,
  });
}
