import 'package:dio/dio.dart';
import '../errors/exceptions.dart';

class NominatimClient {
  late final Dio dio;

  NominatimClient({
    Dio? dioInstance,
    String baseUrl = 'https://nominatim.openstreetmap.org',
    String? userAgent,
  }) {
    dio = dioInstance ?? Dio();
    dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'User-Agent': userAgent, 'Accept-Language': 'ar,en'},
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, handler) {
          // FIX: كان بيعمل throw مباشر جوه onError، وده كان بيخلي Dio
          // يلف الـ exception جوه DioException تاني (type: unknown)
          // فالكود اللي بياخد الـ response مبيقدرش يعمل catch عليه
          // كـ DefaultServerException زي ما هو متوقع. استخدام
          // handler.reject() بيحافظ على النوع الصح جوه DioException.error.
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout) {
            return handler.reject(
              error.copyWith(
                error: const DefaultServerException(
                  message: 'انتهى وقت الاتصال بخدمة Nominatim',
                ),
              ),
            );
          }
          if (error.response?.statusCode == 403) {
            return handler.reject(
              error.copyWith(
                error: const DefaultServerException(
                  message: 'تم حجب الوصول: يرجى إضافة ترويسة User-Agent',
                ),
              ),
            );
          }
          return handler.next(error);
        },
      ),
    );
  }
}
