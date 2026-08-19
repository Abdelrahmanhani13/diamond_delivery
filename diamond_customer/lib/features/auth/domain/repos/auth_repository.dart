import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/auth_tokens.dart';
import '../entities/register_response.dart';
import '../entities/request_otp_response.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthTokens>> login(
    String phoneNumber,
    String password,
    String deviceName,
  );
  
  Future<Either<Failure, RegisterResponse>> register(
    String firstName,
    String lastName,
    String phoneNumber,
    String email,
    String password,
    String roleName,
    String? genderId,
    String? dateOfBirth,
  );
  
  Future<Either<Failure, RequestOtpResponse>> requestOtp(
    String phoneNumber,
    String otpType,
  );
  
  Future<Either<Failure, AuthTokens>> verifyOtp(
    String phoneNumber,
    String code,
    String otpType,
    String deviceName,
  );
  
  Future<Either<Failure, void>> logout(String refreshToken);
  
  Future<Either<Failure, void>> resetPassword(
    String phoneNumber,
    String code,
    String newPassword,
  );
  
  Future<Either<Failure, void>> registerDevice(
    String devicePlatform,
    String deviceId,
    String firebaseToken,
    String appVersion,
  );
}
