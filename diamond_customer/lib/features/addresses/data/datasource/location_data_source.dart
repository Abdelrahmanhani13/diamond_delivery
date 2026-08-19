import 'package:diamond_customer/core/network/nominatim_client.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/errors/exceptions.dart'
    hide LocationServiceDisabledException;
import '../models/geocoded_address_model.dart';

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
          message: ' الموقع الحالي غير متاح',
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
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
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
      // FIX: بنطلع الـ custom exception اللي اتحطت جوه DioException.error
      // في الـ interceptor، بدل ما نسيب DioException الخام يتسرب للـ
      // Repository ويقع في catch(_) العام بتاعها.
      if (e.error is DefaultServerException) {
        throw e.error as DefaultServerException;
      }
      rethrow;
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
      if (e.error is DefaultServerException) {
        throw e.error as DefaultServerException;
      }
      rethrow;
    }
  }
}
