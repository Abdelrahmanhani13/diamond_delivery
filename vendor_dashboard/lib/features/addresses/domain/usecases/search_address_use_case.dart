import 'package:vendor_dashboard/features/addresses/domain/entities/geocoded_address_entity_representing_a_reverse_forward_geocoding_result.dart';
import 'package:vendor_dashboard/features/addresses/domain/repos/location_repo_contract.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';

class SearchAddressUseCase {
  final LocationRepository _repository;

  SearchAddressUseCase(this._repository);

  Future<Either<Failure, List<GeocodedAddress>>> call(String query) =>
      _repository.searchAddress(query);
}
