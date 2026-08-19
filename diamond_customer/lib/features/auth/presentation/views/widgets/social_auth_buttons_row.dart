import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/widgets/social_auth_button.dart';

/// A row of social authentication buttons (Google & Facebook).
class SocialAuthButtonsRow extends StatelessWidget {
  const SocialAuthButtonsRow({
    super.key,
    required this.onGooglePressed,
    required this.onFacebookPressed,
  });

  final VoidCallback onGooglePressed;
  final VoidCallback onFacebookPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SocialAuthButton(
            provider: SocialProvider.google,
            label: 'Google',
            onPressed: onGooglePressed,
          ),
        ),
        Gap(12.w),
        Expanded(
          child: SocialAuthButton(
            provider: SocialProvider.facebook,
            label: 'Facebook',
            onPressed: onFacebookPressed,
          ),
        ),
      ],
    );
  }
}
