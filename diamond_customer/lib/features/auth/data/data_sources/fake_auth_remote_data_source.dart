import '../models/auth_response_model.dart';
import '../models/register_response_model.dart';
import '../models/request_otp_response_model.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  final Duration delay;
  final bool shouldFail;

  FakeAuthRemoteDataSource({
    this.delay = const Duration(milliseconds: 500),
    this.shouldFail = false,
  });

  void _checkFailure() {
    if (shouldFail) {
      throw Exception('Fake auth data source exception');
    }
  }

  @override
  Future<AuthResponseModel> login(
    String phoneNumber,
    String password,
    String deviceName,
  ) async {
    await Future.delayed(delay);
    _checkFailure();

    return AuthResponseModel(
      accessToken: 'fake_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'fake_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      accessTokenExpiresAt: DateTime.now().add(const Duration(days: 30)),
      user: UserModel(
        id: 'fake_user_id_123',
        name: 'Fake User',
        email: 'fakeuser@example.com',
        phone: phoneNumber,
        roles: const ['Customer'],
      ),
    );
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
    await Future.delayed(delay);
    _checkFailure();

    final maskedPhone = phoneNumber.length >= 7
        ? '${phoneNumber.substring(0, 3)}****${phoneNumber.substring(phoneNumber.length - 2)}'
        : phoneNumber;

    return RegisterResponseModel(
      userId: 'fake_user_id_${DateTime.now().millisecondsSinceEpoch}',
      maskedPhoneNumber: maskedPhone,
      otpExpiryMinutes: 5,
    );
  }

  @override
  Future<RequestOtpResponseModel> requestOtp(
    String phoneNumber,
    String otpType,
  ) async {
    await Future.delayed(delay);
    _checkFailure();

    final maskedPhone = phoneNumber.length >= 7
        ? '${phoneNumber.substring(0, 3)}****${phoneNumber.substring(phoneNumber.length - 2)}'
        : phoneNumber;

    return RequestOtpResponseModel(
      maskedPhoneNumber: maskedPhone,
      otpExpiryMinutes: 5,
      resendCooldownSeconds: 60,
    );
  }

  @override
  Future<AuthResponseModel> verifyOtp(
    String phoneNumber,
    String code,
    String otpType,
    String deviceName,
  ) async {
    await Future.delayed(delay);
    _checkFailure();

    return AuthResponseModel(
      accessToken: 'fake_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'fake_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      accessTokenExpiresAt: DateTime.now().add(const Duration(days: 30)),
      user: UserModel(
        id: 'fake_user_id_123',
        name: 'Fake User',
        email: 'fakeuser@example.com',
        phone: phoneNumber,
        roles: const ['Customer'],
      ),
    );
  }

  @override
  Future<void> logout(String refreshToken) async {
    await Future.delayed(delay);
    _checkFailure();
  }

  @override
  Future<void> resetPassword(
    String phoneNumber,
    String code,
    String newPassword,
  ) async {
    await Future.delayed(delay);
    _checkFailure();
  }

  @override
  Future<void> registerDevice(
    String devicePlatform,
    String deviceId,
    String firebaseToken,
    String appVersion,
  ) async {
    await Future.delayed(delay);
    _checkFailure();
  }
}
