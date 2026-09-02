import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../entities/geocoded_address_entity_representing_a_reverse_forward_geocoding_result.dart';
import '../repos/location_repo_contract.dart';

class SearchAddressUseCase {
  final LocationRepository _repository;

  SearchAddressUseCase(this._repository);

  Future<Either<Failure, List<GeocodedAddress>>> call(String query) async {
    return await _repository.searchAddress(query);
  }
}
