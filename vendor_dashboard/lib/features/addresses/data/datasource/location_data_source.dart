import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vendor_dashboard/core/network/nominatim_client.dart';
import '../../../../core/errors/exceptions.dart'
    hide LocationServiceDisabledException;
import '../models/geocoded_address_model.dart';
import 'package:vendor_dashboard/core/errors/exceptions.dart';

abstract class LocationDataSource {
  Future<Position> getCurrentPosition();
  Future<GeocodedAddressModel> reverseGeocode(double lat, double lon);
  Future<List<GeocodedAddressModel>> searchAddress(String query);
}

class LocationDataSourceImpl implements LocationDataSource {
  final NominatimClient _nominatimClient;

  LocationDataSourceImpl(this._nominatimClient);

  @override
  Future<Position> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceDisabledException();
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationPermissionDeniedException(
          message: 'إذن الموقع مرفوض',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationPermissionDeniedException(
        message:
            'تم رفض إذن الموقع بشكل دائم، يرجى تفعيله يدوياً من إعدادات الجهاز',
      );
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
  }

  @override
  Future<GeocodedAddressModel> reverseGeocode(double lat, double lon) async {
    try {
      final response = await _nominatimClient.dio.get<Map<String, dynamic>>(
        '/reverse',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'format': 'jsonv2',
          'addressdetails': 1,
        },
      );
      return GeocodedAddressModel.fromNominatimJson(response.data!);
    } on DioException catch (e) {
      if (e.error is ServerException) {
        throw e.error as ServerException;
      }
      throw const DefaultServerException(
        message: 'تعذر تحديد تفاصيل هذا الموقع',
      );
    }
  }

  @override
  Future<List<GeocodedAddressModel>> searchAddress(String query) async {
    try {
      final response = await _nominatimClient.dio.get<List<dynamic>>(
        '/search',
        queryParameters: {
          'q': query,
          'format': 'jsonv2',
          'addressdetails': 1,
          'limit': 8,
        },
      );
      final results = response.data ?? [];
      return results
          .map(
            (json) => GeocodedAddressModel.fromNominatimJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (e) {
      if (e.error is ServerException) {
        throw e.error as ServerException;
      }
      throw const DefaultServerException(message: 'تعذر البحث عن هذا العنوان');
    }
  }
}
