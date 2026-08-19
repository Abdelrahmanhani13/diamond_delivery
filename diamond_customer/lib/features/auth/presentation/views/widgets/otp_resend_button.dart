import 'package:flutter/material.dart';

import '../../../../../core/theme/app_text_styles.dart';

/// A row showing a prompt to resend the OTP, with a disabled cooldown countdown
/// or an active clickable resend button.
class OtpResendButton extends StatelessWidget {
  const OtpResendButton({
    super.key,
    required this.secondsLeft,
    required this.onResend,
  });

  final int secondsLeft;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('لم يصلك الرمز؟', style: AppTextStyles.bodyMedium),
        TextButton(
          onPressed: secondsLeft == 0 ? onResend : null,
          child: Text(
            secondsLeft == 0
                ? 'إعادة الإرسال'
                : 'إعادة الإرسال ($secondsLeft)',
            style: AppTextStyles.link,
          ),
        ),
      ],
    );
  }
}
