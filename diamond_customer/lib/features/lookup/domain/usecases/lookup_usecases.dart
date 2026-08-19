import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/lookup_item.dart';
import '../repos/lookup_repository.dart';

class GetCountriesUseCase {
  final LookupRepository _repository;

  GetCountriesUseCase(this._repository);

  Future<Either<Failure, List<LookupItem>>> call() {
    return _repository.getCountries();
  }
}

class GetGovernoratesUseCase {
  final LookupRepository _repository;

  GetGovernoratesUseCase(this._repository);

  Future<Either<Failure, List<LookupItem>>> call(String countryId) {
    return _repository.getGovernorates(countryId);
  }
}

class GetCitiesUseCase {
  final LookupRepository _repository;

  GetCitiesUseCase(this._repository);

  Future<Either<Failure, List<LookupItem>>> call(String governorateId) {
    return _repository.getCities(governorateId);
  }
}

// اتشال لأن مفيش endpoint للـ Areas في الـ OpenAPI
// class GetAreasUseCase { ... }

class GetAddressTypesUseCase {
  final LookupRepository _repository;

  GetAddressTypesUseCase(this._repository);

  Future<Either<Failure, List<LookupItem>>> call() {
    return _repository.getAddressTypes();
  }
}

class GetGendersUseCase {
  final LookupRepository _repository;

  GetGendersUseCase(this._repository);

  Future<Either<Failure, List<LookupItem>>> call() {
    return _repository.getGenders();
  }
}
