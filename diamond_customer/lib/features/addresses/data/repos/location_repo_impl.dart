import 'package:diamond_customer/features/addresses/data/datasource/location_data_source.dart';
import 'package:diamond_customer/features/addresses/domain/entities/coordinates_value_entity.dart';
import 'package:diamond_customer/features/addresses/domain/entities/geocoded_address_entity_representing_a_reverse_forward_geocoding_result.dart';
import 'package:diamond_customer/features/addresses/domain/repos/location_repo_contract.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/errors/exceptions.dart'
    hide LocationServiceDisabledException;
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource _dataSource;

  LocationRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, Coordinates>> getCurrentLocation() async {
    try {
      final position = await _dataSource.getCurrentPosition();
      return Right(
        Coordinates(latitude: position.latitude, longitude: position.longitude),
      );
    } on LocationServiceDisabledException {
      return Left(
        LocationFailure(
          message: ' موقعك الحالي غير متاح، يرجى تفعيل خدمات الموقع',
        ),
      );
    } on LocationPermissionDeniedException catch (e) {
      return Left(LocationFailure(message: e.message));
    } catch (_) {
      return const Left(
        LocationFailure(message: 'تعذر تحديد موقعك الحالي، حاول مرة أخرى'),
      );
    }
  }

  @override
  Future<Either<Failure, GeocodedAddress>> reverseGeocode(
    Coordinates coordinates,
  ) async {
    try {
      final result = await _dataSource.reverseGeocode(
        coordinates.latitude,
        coordinates.longitude,
      );
      return Right(result);
    } on DefaultServerException catch (e) {
      // FIX: NominatimClient throws DefaultServerException with a specific
      // Arabic message ("انتهى وقت الاتصال بخدمة Nominatim", "تم حجب
      // الوصول..."). Previously this was swallowed by a bare `catch (_)`
      // and replaced with a generic message, so the specific one never
      // reached the user.
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (_) {
      return const Left(ServerFailure(message: 'تعذر تحديد تفاصيل هذا الموقع'));
    }
  }

  @override
  Future<Either<Failure, List<GeocodedAddress>>> searchAddress(
    String query,
  ) async {
    try {
      final results = await _dataSource.searchAddress(query);
      return Right(results);
    } on DefaultServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (_) {
      return const Left(ServerFailure(message: 'تعذر البحث عن هذا العنوان'));
    }
  }
}
