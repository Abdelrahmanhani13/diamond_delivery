import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/api/api_response.dart';
import '../models/auth_response_model.dart';
import '../models/register_response_model.dart';
import '../models/request_otp_response_model.dart';

abstract class VendorAuthRemoteDataSource {
  Future<AuthResponseModel> login(
    String phoneNumber,
    String password,
    String deviceName,
  );

  Future<RegisterResponseModel> register(
    String firstName,
    String lastName,
    String phoneNumber,
    String email,
    String password,
    String roleName,
    String? genderId,
    String? dateOfBirth,
  );

  Future<RequestOtpResponseModel> requestOtp(
    String phoneNumber,
    String otpType,
  );

  Future<AuthResponseModel> verifyOtp(
    String phoneNumber,
    String code,
    String otpType,
    String deviceName,
  );

  Future<void> logout(String refreshToken);

  Future<void> resetPassword(
    String phoneNumber,
    String code,
    String newPassword,
  );

  Future<void> registerDevice(
    String devicePlatform,
    String deviceId,
    String firebaseToken,
    String appVersion,
  );
}

class AuthRemoteDataSourceImpl implements VendorAuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<AuthResponseModel> login(
    String phoneNumber,
    String password,
    String deviceName,
  ) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      data: {
        'phoneNumber': phoneNumber,
        'password': password,
        'deviceName': deviceName,
      },
    );
    final apiResponse = ApiResponse<AuthResponseModel>.fromJson(
      response,
      (data) => AuthResponseModel.fromJson(data),
    );
    return apiResponse.data!;
  }

  @override
  Future<RegisterResponseModel> register(
    String firstName,
    String lastName,
    String phoneNumber,
    String email,
    String password,
    String roleName,
    String? genderId,
    String? dateOfBirth,
  ) async {
    final data = <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
      'roleName': roleName,
    };
    if (genderId != null) data['genderId'] = genderId;
    if (dateOfBirth != null) data['dateOfBirth'] = dateOfBirth;

    final response = await _apiClient.post(
      ApiConstants.register, // ← اتصلح
      data: data,
    );
    final apiResponse = ApiResponse<RegisterResponseModel>.fromJson(
      response,
      (data) => RegisterResponseModel.fromJson(data),
    );
    return apiResponse.data!;
  }

  @override
  Future<RequestOtpResponseModel> requestOtp(
    String phoneNumber,
    String otpType,
  ) async {
    // كل أنواع الـ OTP بتروح على نفس الـ endpoint
    final response = await _apiClient.post(
      ApiConstants.requestOtp, // ← اتصلح
      data: {
        'phoneNumber': phoneNumber,
        'otpType': otpType, // Login | Registration | ResetPassword ...
      },
    );
    final apiResponse = ApiResponse<RequestOtpResponseModel>.fromJson(
      response,
      (data) => RequestOtpResponseModel.fromJson(data),
    );
    return apiResponse.data!;
  }

  @override
  Future<AuthResponseModel> verifyOtp(
    String phoneNumber,
    String code,
    String otpType,
    String deviceName,
  ) async {
    final response = await _apiClient.post(
      ApiConstants.verifyOtp,
      data: {
        'phoneNumber': phoneNumber,
        'code': code,
        'otpType': otpType,
        'deviceName': deviceName,
      },
    );
    final apiResponse = ApiResponse<AuthResponseModel>.fromJson(
      response,
      (data) => AuthResponseModel.fromJson(data),
    );
    return apiResponse.data!;
  }

  @override
  Future<void> logout(String refreshToken) async {
    await _apiClient.post(
      ApiConstants.logout,
      data: {'refreshToken': refreshToken},
    );
  }

  @override
  Future<void> resetPassword(
    String phoneNumber,
    String code,
    String newPassword,
  ) async {
    await _apiClient.post(
      ApiConstants.resetPassword,
      data: {
        'phoneNumber': phoneNumber,
        'code': code,
        'newPassword': newPassword,
      },
    );
  }

  @override
  Future<void> registerDevice(
    String devicePlatform,
    String deviceId,
    String firebaseToken,
    String appVersion,
  ) async {
    await _apiClient.post(
      ApiConstants.registerDevice,
      data: {
        'devicePlatform': devicePlatform,
        'deviceId': deviceId,
        'firebaseToken': firebaseToken,
        'appVersion': appVersion,
      },
    );
  }
}
