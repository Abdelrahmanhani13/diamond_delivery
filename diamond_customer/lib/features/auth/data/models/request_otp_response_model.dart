import '../../domain/entities/request_otp_response.dart';

class RequestOtpResponseModel extends RequestOtpResponse {
  const RequestOtpResponseModel({
    required super.maskedPhoneNumber,
    required super.otpExpiryMinutes,
    required super.resendCooldownSeconds,
  });

  factory RequestOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return RequestOtpResponseModel(
      maskedPhoneNumber: json['maskedPhoneNumber'] ?? '',
      otpExpiryMinutes: json['otpExpiryMinutes'] ?? 0,
      resendCooldownSeconds: json['resendCooldownSeconds'] ?? 0,
    );
  }
}
