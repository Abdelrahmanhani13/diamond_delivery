import '../../../../core/utils/either.dart';
import '../../../../core/errors/failures.dart';
import '../entities/home_data.dart';
import '../repos/home_repo.dart';

class GetHomeDataUseCase {
  final HomeRepo repo;

  GetHomeDataUseCase(this.repo);

  Future<Either<Failure, HomeData>> call({
    required double latitude,
    required double longitude,
  }) async {
    return await repo.getHomeData(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
