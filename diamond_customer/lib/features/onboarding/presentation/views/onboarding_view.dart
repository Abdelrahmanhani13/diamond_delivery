import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/divider_with_label.dart';
import '../../../../core/widgets/social_auth_button.dart';

/// Single-screen Hero Onboarding containing looping Lottie illustration
/// and elegant authentication actions. Custom-designed to feel premium.
class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Column(
          children: [
            // 1. Premium Header with Talabat-like Curved Bottom
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
                        AppColors.primaryLight.withValues(alpha: 0.8),
                        AppColors.primary.withValues(alpha: 0.15),
                      ],
                    ),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Lottie Animation filling the top section
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

            // 2. Authentication and Content Section
            Expanded(
              flex: 6,
              child: SafeArea(
                top: false, // Only apply safe area to bottom/sides
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Gap(10.h),
                        Text(
                              'Diamond Village',
                              style: AppTextStyles.displayLarge.copyWith(
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                              ),
                              textAlign: TextAlign.center,
                            )
                            .animate()
                            .fadeIn(delay: 200.ms)
                            .slideY(begin: 0.2, end: 0, duration: 400.ms),

                        Gap(6.h),

                        Text(
                              'كل ما تحتاجه يصل إلى بابك — توصيل سريع وآمن من أفضل المتاجر المحلية',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            )
                            .animate()
                            .fadeIn(delay: 350.ms)
                            .slideY(begin: 0.2, end: 0, duration: 400.ms),

                        Gap(20.h),

                        // Login / Register buttons side-by-side
                        Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                label: 'تسجيل دخول',
                                variant: AppButtonVariant.outline,
                                icon: Icons.login_rounded,
                                onPressed: () => context.go(AppRoutes.login),
                              ),
                            ),
                            Gap(10.w),
                            Expanded(
                              child: AppButton(
                                label: 'حساب جديد',
                                variant: AppButtonVariant.secondary,
                                icon: Icons.person_add_alt_1_rounded,
                                onPressed: () => context.go(AppRoutes.register),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 650.ms),

                        Gap(16.h),

                        // Social integration
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
      ),
    );
  }
}

/// Custom Clipper to draw Talabat-style curve at the bottom of the header
class BottomArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 35);

    // Creates a smooth subtle downward curve in the middle
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
