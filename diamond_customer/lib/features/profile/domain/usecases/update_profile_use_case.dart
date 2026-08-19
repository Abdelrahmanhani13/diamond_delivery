import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/profile_entity.dart';
import '../repos/profile_repository.dart';
import '../../data/models/update_profile_request_model.dart';

class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<Either<Failure, ProfileEntity>> call(UpdateProfileRequestModel request) {
    return _repository.updateProfile(request);
  }
}
