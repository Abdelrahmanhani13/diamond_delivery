import 'package:diamond_customer/core/api/api_error.dart';

abstract class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final List<ApiError>? errors;

  const ServerException({required this.message, this.statusCode, this.errors});
}

class DefaultServerException extends ServerException {
  const DefaultServerException({
    required super.message,
    super.statusCode,
    super.errors,
  });
}

class BadRequestException extends ServerException {
  const BadRequestException({
    required super.message,
    super.statusCode = 400,
    super.errors,
  });
}

class UnauthorizedException extends ServerException {
  const UnauthorizedException({
    super.message = 'Unauthorized access',
    super.statusCode = 401,
    super.errors,
  });
}

class ForbiddenException extends ServerException {
  const ForbiddenException({
    super.message = 'Access forbidden',
    super.statusCode = 403,
    super.errors,
  });
}

class NotFoundException extends ServerException {
  const NotFoundException({
    super.message = 'Resource not found',
    super.statusCode = 404,
    super.errors,
  });
}

class ConflictException extends ServerException {
  const ConflictException({
    super.message = 'Resource conflict',
    super.statusCode = 409,
    super.errors,
  });
}

class UnprocessableEntityException extends ServerException {
  const UnprocessableEntityException({
    super.message = 'Unprocessable entity',
    super.statusCode = 422,
    super.errors,
  });
}

class TooManyRequestsException extends ServerException {
  const TooManyRequestsException({
    super.message = 'Too many requests',
    super.statusCode = 429,
    super.errors,
  });
}

class InternalServerException extends ServerException {
  const InternalServerException({
    super.message = 'Internal server error',
    super.statusCode = 500,
    super.errors,
  });
}

class BadGatewayException extends ServerException {
  const BadGatewayException({
    super.message = 'Bad gateway',
    super.statusCode = 502,
    super.errors,
  });
}

class ServiceUnavailableException extends ServerException {
  const ServiceUnavailableException({
    super.message = 'Service unavailable',
    super.statusCode = 503,
    super.errors,
  });
}

class GatewayTimeoutException extends ServerException {
  const GatewayTimeoutException({
    super.message = 'Gateway timeout',
    super.statusCode = 504,
    super.errors,
  });
}

class CacheException implements Exception {
  final String message;
  const CacheException({required this.message});
}

class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'No internet connection'});
}

class LocationPermissionDeniedException implements Exception {
  final String message;
  const LocationPermissionDeniedException({required this.message});
}

class LocationServiceDisabledException implements Exception {
  final String message;
  const LocationServiceDisabledException({
    this.message = 'Location service is disabled',
  });
}

class LocationException implements Exception {
  final String message;
  const LocationException({required this.message});
}
