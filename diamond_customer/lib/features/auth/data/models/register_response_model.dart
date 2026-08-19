import '../../domain/entities/register_response.dart';

class RegisterResponseModel extends RegisterResponse {
  const RegisterResponseModel({
    required super.userId,
    required super.maskedPhoneNumber,
    required super.otpExpiryMinutes,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      userId: json['userId'] ?? '',
      maskedPhoneNumber: json['maskedPhoneNumber'] ?? '',
      otpExpiryMinutes: json['otpExpiryMinutes'] ?? 0,
    );
  }
}
