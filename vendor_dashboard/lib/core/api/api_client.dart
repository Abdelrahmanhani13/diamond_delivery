import 'dart:io';
import 'package:dio/dio.dart';
import '../errors/exceptions.dart';
import 'api_error.dart';
import 'package:vendor_dashboard/core/api/api_client.dart';

enum _HttpMethod { get, post, put, patch, delete }

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _request(_HttpMethod.get, path, queryParameters: queryParameters);
  }

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      _HttpMethod.post,
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      _HttpMethod.put,
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      _HttpMethod.patch,
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      _HttpMethod.delete,
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> _request(
    _HttpMethod method,
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response response;
      switch (method) {
        case _HttpMethod.get:
          response = await _dio.get(path, queryParameters: queryParameters);
        case _HttpMethod.post:
          response = await _dio.post(
            path,
            data: data,
            queryParameters: queryParameters,
          );
        case _HttpMethod.put:
          response = await _dio.put(
            path,
            data: data,
            queryParameters: queryParameters,
          );
        case _HttpMethod.patch:
          response = await _dio.patch(
            path,
            data: data,
            queryParameters: queryParameters,
          );
        case _HttpMethod.delete:
          response = await _dio.delete(
            path,
            data: data,
            queryParameters: queryParameters,
          );
      }
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  String _extractErrorMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return error.message ?? 'Server error occurred';
  }

  List<ApiError>? _extractErrors(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic> && data['errors'] is List) {
      try {
        return (data['errors'] as List<dynamic>)
            .map((e) => ApiError.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Never _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        throw const NetworkException();

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _extractErrorMessage(error);
        final errors = _extractErrors(error);

        switch (statusCode) {
          case 400:
            throw BadRequestException(message: message, errors: errors);
          case 401:
            throw UnauthorizedException(message: message, errors: errors);
          case 403:
            throw ForbiddenException(message: message, errors: errors);
          case 404:
            throw NotFoundException(message: message, errors: errors);
          case 409:
            throw ConflictException(message: message, errors: errors);
          case 422:
            throw UnprocessableEntityException(
              message: message,
              errors: errors,
            );
          case 429:
            throw TooManyRequestsException(message: message, errors: errors);
          case 500:
            throw InternalServerException(message: message, errors: errors);
          case 502:
            throw BadGatewayException(message: message, errors: errors);
          case 503:
            throw ServiceUnavailableException(message: message, errors: errors);
          case 504:
            throw GatewayTimeoutException(message: message, errors: errors);
          default:
            throw DefaultServerException(
              message: message,
              statusCode: statusCode,
              errors: errors,
            );
        }

      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          throw const NetworkException();
        }
        throw DefaultServerException(
          message: error.message ?? 'Unknown network error',
        );

      case DioExceptionType.badCertificate:
        throw const DefaultServerException(
          message: 'Invalid security certificate',
        );

      case DioExceptionType.transformTimeout:
        throw const NetworkException(
          message: 'The connection took too long to process',
        );
    }
  }
}
