import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/exceptions.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import 'package:vendor_dashboard/core/network/network_info.dart';
import '../datasources/vendor_auth_local_data_source.dart';
import '../datasources/vendor_auth_remote_data_source.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/register_response.dart';
import '../../domain/entities/request_otp_response.dart';
import '../../domain/repositories/vendor_auth_repository.dart';

class AuthRepositoryImpl implements VendorAuthRepository {
  final VendorAuthRemoteDataSource _remoteDataSource;
  final VendorAuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl({
    required VendorAuthRemoteDataSource remoteDataSource,
    required VendorAuthLocalDataSource localDataSource,
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
      if (response.user != null) {
        await _localDataSource.saveUserData({
          'userId': response.user!.id,
          'fullName': response.user!.name,
          'email': response.user!.email,
          'phoneNumber': response.user!.phone,
        });
      }
      return Right(response.toTokensEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
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
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
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
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
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
      if (response.user != null) {
        await _localDataSource.saveUserData({
          'userId': response.user!.id,
          'fullName': response.user!.name,
          'email': response.user!.email,
          'phoneNumber': response.user!.phone,
        });
      }
      return Right(response.toTokensEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
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
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
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
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
