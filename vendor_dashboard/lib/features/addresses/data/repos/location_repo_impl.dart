import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/exceptions.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import 'package:vendor_dashboard/features/addresses/data/datasource/location_data_source.dart';
import 'package:vendor_dashboard/features/addresses/domain/entities/coordinates_value_entity.dart';
import 'package:vendor_dashboard/features/addresses/domain/entities/geocoded_address_entity_representing_a_reverse_forward_geocoding_result.dart';
import 'package:vendor_dashboard/features/addresses/domain/repos/location_repo_contract.dart';

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
    } on LocationServiceDisabledException catch (e) {
      return Left(LocationServiceDisabledFailure(e.message));
    } on LocationPermissionDeniedException catch (e) {
      return Left(LocationPermissionDeniedFailure(e.message));
    } on LocationException catch (e) {
      return Left(LocationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (_) {
      return const Left(LocationFailure());
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
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (_) {
      return const Left(ServerFailure('تعذر تحديد تفاصيل هذا الموقع'));
    }
  }

  @override
  Future<Either<Failure, List<GeocodedAddress>>> searchAddress(
    String query,
  ) async {
    try {
      final results = await _dataSource.searchAddress(query);
      return Right(results);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (_) {
      return const Left(ServerFailure('تعذر البحث عن هذا العنوان'));
    }
  }
}
