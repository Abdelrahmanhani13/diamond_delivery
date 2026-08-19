import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repos/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/update_profile_request_model.dart';
import 'package:diamond_customer/core/errors/exceptions.dart';
import 'package:diamond_customer/core/network/network_info.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  // لسه محتفظين بيه للـ DI؛ مش بيتستخدم حالياً لأن getProfile/
  // updateProfile بقوا محليين (مفيش endpoint حقيقي).
  // ignore: unused_field
  final NetworkInfo _networkInfo;

  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    try {
      final result = await _remoteDataSource.getProfile();
      return Right(result);
    } on CacheException catch (e) {
      // FIX: ده الاستثناء المتوقع فعلياً دلوقتي (لا يوجد بيانات محلية)،
      // مكنش متعامل معاه وكان بيقع في catch(e) العام تحت.
      return Left(CacheFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, errors: e.errors));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(
    UpdateProfileRequestModel request,
  ) async {
    try {
      final result = await _remoteDataSource.updateProfile(request);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, errors: e.errors));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }
}
