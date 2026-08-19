import 'package:vendor_dashboard/core/api/api_response.dart';
import 'package:vendor_dashboard/core/errors/exceptions.dart';

/// Base Exception لجميع استثناءات الشبكة والنظام
abstract class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final List<ApiError>? errors;

  const ServerException({required this.message, this.statusCode, this.errors});
}

/// 400 Bad Request
class BadRequestException extends ServerException {
  const BadRequestException({required super.message, super.errors})
    : super(statusCode: 400);
}

/// 401 Unauthorized
class UnauthorizedException extends ServerException {
  const UnauthorizedException({required super.message, super.errors})
    : super(statusCode: 401);
}

/// 403 Forbidden
class ForbiddenException extends ServerException {
  const ForbiddenException({required super.message, super.errors})
    : super(statusCode: 403);
}

/// 404 Not Found
class NotFoundException extends ServerException {
  const NotFoundException({required super.message, super.errors})
    : super(statusCode: 404);
}

/// 409 Conflict
class ConflictException extends ServerException {
  const ConflictException({required super.message, super.errors})
    : super(statusCode: 409);
}

/// 422 Unprocessable Entity (أخطاء المدخلات والـ Validation)
class UnprocessableEntityException extends ServerException {
  const UnprocessableEntityException({required super.message, super.errors})
    : super(statusCode: 422);
}

/// 429 Too Many Requests
class TooManyRequestsException extends ServerException {
  const TooManyRequestsException({required super.message, super.errors})
    : super(statusCode: 429);
}

/// 500 Internal Server Error
class InternalServerException extends ServerException {
  const InternalServerException({required super.message, super.errors})
    : super(statusCode: 500);
}

/// 502 Bad Gateway
class BadGatewayException extends ServerException {
  const BadGatewayException({required super.message, super.errors})
    : super(statusCode: 502);
}

/// 503 Service Unavailable
class ServiceUnavailableException extends ServerException {
  const ServiceUnavailableException({required super.message, super.errors})
    : super(statusCode: 503);
}

/// 504 Gateway Timeout
class GatewayTimeoutException extends ServerException {
  const GatewayTimeoutException({required super.message, super.errors})
    : super(statusCode: 504);
}

/// استثناء الأخطاء الافتراضية للـ Status Codes غير المعرفة
class DefaultServerException extends ServerException {
  const DefaultServerException({
    required super.message,
    super.statusCode,
    super.errors,
  });
}

/// استثناء انقطاع الاتصال أو Timeout
class NetworkException extends ServerException {
  const NetworkException({
    super.message = 'لا يوجد اتصال بالإنترنت، يرجى التأكد من الشبكة',
  }) : super(statusCode: null);
}

/// خدمة الموقع مقفولة على الجهاز
class LocationServiceDisabledException extends ServerException {
  const LocationServiceDisabledException({
    super.message = 'خدمات الموقع غير مفعّلة، يرجى تفعيلها من الإعدادات',
  }) : super(statusCode: null);
}

/// إذن الموقع مرفوض
class LocationPermissionDeniedException extends ServerException {
  const LocationPermissionDeniedException({
    super.message = 'تم رفض إذن الوصول للموقع',
  }) : super(statusCode: null);
}

/// فشل عام في تحديد الموقع
class LocationException extends ServerException {
  const LocationException({super.message = 'تعذر تحديد الموقع الحالي'})
    : super(statusCode: null);
}
