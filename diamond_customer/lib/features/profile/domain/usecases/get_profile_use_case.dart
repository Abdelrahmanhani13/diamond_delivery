import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/profile_entity.dart';
import '../repos/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  Future<Either<Failure, ProfileEntity>> call() {
    return _repository.getProfile();
  }
}
