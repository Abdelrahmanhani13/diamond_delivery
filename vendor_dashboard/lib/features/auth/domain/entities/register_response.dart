import 'package:equatable/equatable.dart';

class RegisterResponse extends Equatable {
  final String userId;
  final String maskedPhoneNumber;
  final int otpExpiryMinutes;

  const RegisterResponse({
    required this.userId,
    required this.maskedPhoneNumber,
    required this.otpExpiryMinutes,
  });

  @override
  List<Object?> get props => [userId, maskedPhoneNumber, otpExpiryMinutes];
}
