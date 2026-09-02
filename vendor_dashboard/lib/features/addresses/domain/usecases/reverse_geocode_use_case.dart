import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../entities/coordinates_value_entity.dart';
import '../entities/geocoded_address_entity_representing_a_reverse_forward_geocoding_result.dart';
import '../repos/location_repo_contract.dart';

class ReverseGeocodeUseCase {
  final LocationRepository _repository;

  ReverseGeocodeUseCase(this._repository);

  Future<Either<Failure, GeocodedAddress>> call(double lat, double lon) async {
    return await _repository.reverseGeocode(
      Coordinates(latitude: lat, longitude: lon),
    );
  }
}
