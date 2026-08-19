import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/profile_entity.dart';
import '../../data/models/update_profile_request_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile();
  Future<Either<Failure, ProfileEntity>> updateProfile(UpdateProfileRequestModel request);
}
