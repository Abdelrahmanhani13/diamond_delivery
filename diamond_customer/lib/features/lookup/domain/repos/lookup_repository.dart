import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/lookup_item.dart';

abstract class LookupRepository {
  Future<Either<Failure, List<LookupItem>>> getCountries();
  Future<Either<Failure, List<LookupItem>>> getGovernorates(String countryId);
  Future<Either<Failure, List<LookupItem>>> getCities(String governorateId);
  Future<Either<Failure, List<LookupItem>>> getAddressTypes();
  Future<Either<Failure, List<LookupItem>>> getGenders();
}
