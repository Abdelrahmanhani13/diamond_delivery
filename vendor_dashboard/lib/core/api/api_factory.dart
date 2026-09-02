import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../cache/secure_storage_service.dart';
import '../network/auth_event_bus.dart';
import 'api_constants.dart';

class _RefreshTokenResult {
  final String accessToken;
  final String refreshToken;

  const _RefreshTokenResult({
    required this.accessToken,
    required this.refreshToken,
  });

  static _RefreshTokenResult? tryParse(dynamic responseData) {
    if (responseData is! Map<String, dynamic>) return null;
    final data = responseData['data'];
    if (data is! Map<String, dynamic>) return null;

    final accessToken = data['accessToken'];
    final refreshToken = data['refreshToken'];
    if (accessToken is! String || refreshToken is! String) return null;
    if (accessToken.isEmpty || refreshToken.isEmpty) return null;

    return _RefreshTokenResult(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}

class DioFactory {
  final SecureStorageService _storageService;
  final AuthEventBus _authEventBus;

  static const int _maxRetriesPerRequest = 1;
  static const String _retryCountKey = 'x-retry-count';

  DioFactory(this._storageService, this._authEventBus);

  late final Dio _refreshDio = Dio(
    BaseOptions(
      baseUrl: AuthApiConstants.baseUrl,
      connectTimeout: AuthApiConstants.timeout,
      receiveTimeout: AuthApiConstants.timeout,
      headers: {
        'Content-Type': AuthApiConstants.contentType,
        'Accept': AuthApiConstants.accept,
      },
    ),
  );

  Completer<bool>? _refreshCompleter;

  Dio createDio({String baseUrl = AuthApiConstants.baseUrl}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: AuthApiConstants.timeout,
        receiveTimeout: AuthApiConstants.timeout,
        headers: {
          'Content-Type': AuthApiConstants.contentType,
          'Accept': AuthApiConstants.accept,
        },
      ),
    );

    dio.interceptors.add(_buildAuthInterceptor(dio));

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }

    return dio;
  }

  InterceptorsWrapper _buildAuthInterceptor(Dio dio) {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final noAuthPaths = [
          AuthApiConstants.login,
          AuthApiConstants.register,
          AuthApiConstants.requestOtp,
          AuthApiConstants.verifyOtp,
          AuthApiConstants.resetPassword,
          AuthApiConstants.refreshToken,
        ];

        if (!noAuthPaths.contains(options.path)) {
          final token = await _storageService.read(
            SecureStorageServiceImpl.keyAccessToken,
          );
          if (token != null && token.isNotEmpty) {
            options.headers[AuthApiConstants.authorization] =
                '${AuthApiConstants.bearer} $token';
          }
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        final isUnauthorized = error.response?.statusCode == 401;
        final isRefreshCall =
            error.requestOptions.path == AuthApiConstants.refreshToken;
        final retryCount =
            (error.requestOptions.extra[_retryCountKey] as int?) ?? 0;

        final canRetry =
            isUnauthorized &&
            !isRefreshCall &&
            retryCount < _maxRetriesPerRequest;

        if (!canRetry) {
          if (isUnauthorized && !isRefreshCall) {
            await _storageService.clearAll();
            _authEventBus.emit(AuthEvent.forcedLogout);
          }
          return handler.next(error);
        }

        final refreshed = await _tryRefreshToken();
        if (!refreshed) {
          await _storageService.clearAll();
          _authEventBus.emit(AuthEvent.forcedLogout);
          return handler.next(error);
        }

        final newToken = await _storageService.read(
          SecureStorageServiceImpl.keyAccessToken,
        );

        final retryOptions = error.requestOptions
          ..headers[AuthApiConstants.authorization] =
              '${AuthApiConstants.bearer} $newToken'
          ..extra[_retryCountKey] = retryCount + 1;

        try {
          final response = await dio.fetch(retryOptions);
          return handler.resolve(response);
        } on DioException catch (retryError) {
          return handler.next(retryError);
        }
      },
    );
  }

  Future<bool> _tryRefreshToken() {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }
    final completer = Completer<bool>();
    _refreshCompleter = completer;

    _performRefresh().then((result) {
      completer.complete(result);
      _refreshCompleter = null;
    });

    return completer.future;
  }

  Future<bool> _performRefresh() async {
    try {
      final refreshToken = await _storageService.read(
        SecureStorageServiceImpl.keyRefreshToken,
      );
      if (refreshToken == null || refreshToken.isEmpty) return false;

      final response = await _refreshDio.post(
        AuthApiConstants.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode != 200) return false;

      final result = _RefreshTokenResult.tryParse(response.data);
      if (result == null) return false;

      await _storageService.write(
        SecureStorageServiceImpl.keyAccessToken,
        result.accessToken,
      );
      await _storageService.write(
        SecureStorageServiceImpl.keyRefreshToken,
        result.refreshToken,
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
