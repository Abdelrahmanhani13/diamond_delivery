import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import 'package:vendor_dashboard/features/addresses/domain/entities/coordinates_value_entity.dart';
import 'package:vendor_dashboard/features/addresses/domain/entities/geocoded_address_entity_representing_a_reverse_forward_geocoding_result.dart';

abstract class LocationRepository {
  Future<Either<Failure, Coordinates>> getCurrentLocation();

  Future<Either<Failure, GeocodedAddress>> reverseGeocode(
    Coordinates coordinates,
  );

  Future<Either<Failure, List<GeocodedAddress>>> searchAddress(String query);
}
