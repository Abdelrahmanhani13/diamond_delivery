import 'package:vendor_dashboard/core/api/api_error.dart';
import 'exceptions.dart';

abstract class Failure {
  final String errMessage;
  final List<ApiError>? errors;

  const Failure(this.errMessage, {this.errors});
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.errMessage, {this.statusCode, super.errors});

  /// Factory تحويل أي Exception مرمي من ApiClient إلى ServerFailure
  factory ServerFailure.fromException(Object exception) {
    if (exception is ServerException) {
      return ServerFailure(
        exception.message,
        statusCode: exception.statusCode,
        errors: exception.errors,
      );
    }
    return ServerFailure('حدث خطأ غير متوقع: ${exception.toString()}');
  }
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.errMessage = 'لا يوجد اتصال بالإنترنت، يرجى إعادة المحاولة',
  ]);
}

class LocationServiceDisabledFailure extends Failure {
  const LocationServiceDisabledFailure([
    super.errMessage = 'خدمات الموقع غير مفعّلة، يرجى تفعيلها من الإعدادات',
  ]);
}

class LocationPermissionDeniedFailure extends Failure {
  const LocationPermissionDeniedFailure([
    super.errMessage = 'تم رفض إذن الوصول للموقع',
  ]);
}

class LocationFailure extends Failure {
  const LocationFailure([super.errMessage = 'تعذر تحديد الموقع الحالي']);
}
