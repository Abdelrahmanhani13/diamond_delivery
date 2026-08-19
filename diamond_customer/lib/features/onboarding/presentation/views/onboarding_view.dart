import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/divider_with_label.dart';
import '../../../../core/widgets/social_auth_button.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: ClipPath(
              clipper: BottomArcClipper(),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      context.primaryThemeColor.withValues(alpha: 0.3),
                      context.primaryThemeColor.withValues(alpha: 0.08),
                    ],
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Lottie.asset(
                      Assets.lottie.onboardingDelivery,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            flex: 6,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Gap(10.h),
                      Text(
                            context.tr('appName'),
                            style: AppTextStyles.displayLarge.copyWith(
                              fontWeight: FontWeight.w900,
                              color: context.primaryThemeColor,
                            ),
                            textAlign: TextAlign.center,
                          )
                          .animate()
                          .fadeIn(delay: 200.ms)
                          .slideY(begin: 0.2, end: 0, duration: 400.ms),

                      Gap(6.h),

                      Text(
                            context.isArabic
                                ? 'كل ما تحتاجه يصل إلى بابك — توصيل سريع وآمن من أفضل المتاجر المحلية'
                                : 'Everything you need delivered to your door — fast & secure delivery from local stores',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: context.textSecondaryColor,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          )
                          .animate()
                          .fadeIn(delay: 350.ms)
                          .slideY(begin: 0.2, end: 0, duration: 400.ms),

                      Gap(20.h),

                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              label: context.tr('login'),
                              variant: AppButtonVariant.outline,
                              icon: Icons.login_rounded,
                              onPressed: () => context.go(AppRoutes.login),
                            ),
                          ),
                          Gap(10.w),
                          Expanded(
                            child: AppButton(
                              label: context.tr('register'),
                              variant: AppButtonVariant.secondary,
                              icon: Icons.person_add_alt_1_rounded,
                              onPressed: () => context.go(AppRoutes.register),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 650.ms),

                      Gap(16.h),

                      const DividerWithLabel(label: 'أو تابع باستخدام'),

                      Gap(12.h),

                      Row(
                        children: [
                          Expanded(
                            child: SocialAuthButton(
                              provider: SocialProvider.google,
                              label: 'Google',
                              onPressed: () => context.go(AppRoutes.home),
                            ),
                          ),
                          Gap(10.w),
                          Expanded(
                            child: SocialAuthButton(
                              provider: SocialProvider.facebook,
                              label: 'Facebook',
                              onPressed: () => context.go(AppRoutes.home),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 800.ms),

                      Gap(12.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 35);

    final controlPoint = Offset(size.width / 2, size.height + 15);
    final endPoint = Offset(size.width, size.height - 35);

    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
