import '../views/otp_verification_view.dart';

class OTPValidator {
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رمز التحقق مطلوب';
    }
    if (value.trim().length != kOtpLength) {
      return 'يجب أن يتكون الرمز من $kOtpLength أرقام';
    }
    return null;
  }
}
