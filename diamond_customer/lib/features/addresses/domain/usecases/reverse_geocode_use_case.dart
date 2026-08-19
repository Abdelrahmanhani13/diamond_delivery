import 'package:diamond_customer/features/addresses/domain/entities/geocoded_address_entity_representing_a_reverse_forward_geocoding_result.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/coordinates_value_entity.dart';
import '../repos/location_repo_contract.dart';

class ReverseGeocodeUseCase {
  final LocationRepository _repository;

  ReverseGeocodeUseCase(this._repository);

  Future<Either<Failure, GeocodedAddress>> call(Coordinates coordinates) =>
      _repository.reverseGeocode(coordinates);
}
