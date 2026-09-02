import 'package:equatable/equatable.dart';

class RequestOtpResponse extends Equatable {
  final String maskedPhoneNumber;
  final int otpExpiryMinutes;
  final int resendCooldownSeconds;

  const RequestOtpResponse({
    required this.maskedPhoneNumber,
    required this.otpExpiryMinutes,
    required this.resendCooldownSeconds,
  });

  @override
  List<Object?> get props => [
    maskedPhoneNumber,
    otpExpiryMinutes,
    resendCooldownSeconds,
  ];
}
