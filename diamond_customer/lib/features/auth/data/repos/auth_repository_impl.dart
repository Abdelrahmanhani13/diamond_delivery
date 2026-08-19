import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/register_response.dart';
import '../../domain/entities/request_otp_response.dart';
import 'package:diamond_customer/features/auth/domain/repos/auth_repository.dart';
import 'package:diamond_customer/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:diamond_customer/features/auth/data/data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, AuthTokens>> login(
    String phoneNumber,
    String password,
    String deviceName,
  ) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final response = await _remoteDataSource.login(
        phoneNumber,
        password,
        deviceName,
      );
      await _localDataSource.saveTokens(
        response.accessToken,
        response.refreshToken,
        response.accessTokenExpiresAt,
      );
      // Persist user data from auth response (merge with existing local data if present)
      final existing = await _localDataSource.getUserData() ?? {};
      if (response.user != null && response.user!.name.isNotEmpty) {
        await _localDataSource.saveUserData({
          ...existing,
          'userId': _firstNonEmpty(response.user!.id, existing['userId']?.toString()),
          'fullName': _firstNonEmpty(response.user!.name, existing['fullName']?.toString()),
          'email': _firstNonEmpty(response.user!.email, existing['email']?.toString()),
          'phoneNumber': _firstNonEmpty(response.user!.phone, existing['phoneNumber']?.toString()),
        });
      } else {
        // Fallback: extract user info from JWT token when API doesn't
        // return user fields in the response body
        await _saveUserDataFromToken(response.accessToken, phoneNumber);
      }
      return Right(response.toTokensEntity());
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
          errors: e.errors,
        ),
      );
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }


  @override
  Future<Either<Failure, RegisterResponse>> register(
    String firstName,
    String lastName,
    String phoneNumber,
    String email,
    String password,
    String roleName,
    String? genderId,
    String? dateOfBirth,
  ) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final response = await _remoteDataSource.register(
        firstName,
        lastName,
        phoneNumber,
        email,
        password,
        roleName,
        genderId,
        dateOfBirth,
      );
      // Immediately save registered name and contact details to local storage
      final fullName = '$firstName $lastName'.trim();
      await _localDataSource.saveUserData({
        'userId': response.userId,
        'firstName': firstName,
        'lastName': lastName,
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
      });
      return Right(response);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
          errors: e.errors,
        ),
      );
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, RequestOtpResponse>> requestOtp(
    String phoneNumber,
    String otpType,
  ) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final response = await _remoteDataSource.requestOtp(phoneNumber, otpType);
      return Right(response);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
          errors: e.errors,
        ),
      );
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> verifyOtp(
    String phoneNumber,
    String code,
    String otpType,
    String deviceName,
  ) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final response = await _remoteDataSource.verifyOtp(
        phoneNumber,
        code,
        otpType,
        deviceName,
      );
      await _localDataSource.saveTokens(
        response.accessToken,
        response.refreshToken,
        response.accessTokenExpiresAt,
      );
      // Persist user data from OTP verification response (merge with registration data if exists)
      final existing = await _localDataSource.getUserData() ?? {};
      if (response.user != null && response.user!.name.isNotEmpty) {
        await _localDataSource.saveUserData({
          ...existing,
          'userId': _firstNonEmpty(response.user!.id, existing['userId']?.toString()),
          'fullName': _firstNonEmpty(response.user!.name, existing['fullName']?.toString()),
          'email': _firstNonEmpty(response.user!.email, existing['email']?.toString()),
          'phoneNumber': _firstNonEmpty(response.user!.phone, existing['phoneNumber']?.toString()),
        });
      } else {
        await _saveUserDataFromToken(response.accessToken, phoneNumber);
      }
      return Right(response.toTokensEntity());
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
          errors: e.errors,
        ),
      );
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout(String refreshToken) async {
    try {
      if (await _networkInfo.isConnected) {
        await _remoteDataSource.logout(refreshToken);
      }
      await _localDataSource.clearAll();
      return const Right(null);
    } catch (_) {
      await _localDataSource.clearAll();
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
    String phoneNumber,
    String code,
    String newPassword,
  ) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await _remoteDataSource.resetPassword(phoneNumber, code, newPassword);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
          errors: e.errors,
        ),
      );
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> registerDevice(
    String devicePlatform,
    String deviceId,
    String firebaseToken,
    String appVersion,
  ) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await _remoteDataSource.registerDevice(
        devicePlatform,
        deviceId,
        firebaseToken,
        appVersion,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
          errors: e.errors,
        ),
      );
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  /// Decodes the JWT access token payload to extract user claims and
  /// persist them as User_Data. This ensures the Profile page always
  /// has name/email/phone available even when the API response body
  /// doesn't include user fields.
  Future<void> _saveUserDataFromToken(
    String accessToken,
    String phoneNumber,
  ) async {
    final existing = await _localDataSource.getUserData() ?? {};
    try {
      final parts = accessToken.split('.');
      if (parts.length != 3) return;

      String payload = parts[1];
      while (payload.length % 4 != 0) {
        payload += '=';
      }
      final decoded = utf8.decode(base64Url.decode(payload));
      final Map<String, dynamic> claims = json.decode(decoded);

      const ns = 'http://schemas.xmlsoap.org/ws/2005/05/identity/claims';

      final userId = claims['$ns/nameidentifier'] ??
          claims['nameid'] ??
          claims['uid'] ??
          claims['sub'] ??
          claims['userId'] ??
          claims['id'] ??
          '';
      final name = claims['$ns/name'] ??
          claims['$ns/givenname'] ??
          claims['full_name'] ??
          claims['fullName'] ??
          claims['FullName'] ??
          claims['name'] ??
          claims['unique_name'] ??
          '';
      final email = claims['$ns/emailaddress'] ??
          claims['email'] ??
          claims['emailAddress'] ??
          '';
      final phone = claims['$ns/mobilephone'] ??
          claims['phone_number'] ??
          claims['phoneNumber'] ??
          phoneNumber;

      await _localDataSource.saveUserData({
        ...existing,
        'userId': _firstNonEmpty(userId.toString(), existing['userId']?.toString()),
        'fullName': _firstNonEmpty(name.toString(), existing['fullName']?.toString()),
        'email': _firstNonEmpty(email.toString(), existing['email']?.toString()),
        'phoneNumber': _firstNonEmpty(phone.toString(), existing['phoneNumber']?.toString()),
      });
    } catch (_) {
      if (existing.isEmpty) {
        await _localDataSource.saveUserData({
          'userId': '',
          'fullName': '',
          'email': '',
          'phoneNumber': phoneNumber,
        });
      }
    }
  }

  static String _firstNonEmpty(String a, String? b) {
    if (a.isNotEmpty) return a;
    if (b != null && b.isNotEmpty) return b;
    return '';
  }
}
