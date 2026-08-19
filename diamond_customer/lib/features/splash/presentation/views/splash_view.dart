import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';

import 'widgets/ambient_glow_circles.dart';
import 'widgets/decorative_rings.dart';
import 'widgets/brand_header.dart';
import 'widgets/animated_loader.dart';
import 'package:diamond_customer/features/auth/data/data_sources/auth_local_data_source.dart';

/// Branded splash with premium animated entrance, soft ambient glow circles,
/// and automatic session restore — routes to home if the user is already
/// logged in, or to onboarding otherwise.
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    // Wait for splash animation to play
    await Future.delayed(const Duration(milliseconds: 3500));
    if (!mounted) return;

    // Check if the user has a saved session
    final authLocal = getIt<AuthLocalDataSource>();
    final isLoggedIn = await authLocal.isLoggedIn();

    if (!mounted) return;
    if (isLoggedIn) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF073F37), // Darker rich green-teal
                Color(0xFF0F7A6D), // Primary brand teal
                Color(0xFF073F37), // Deep teal
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const AmbientGlowCircles(),
              const DecorativeRings(),
              const BrandHeader(),
              Positioned(
                bottom: 80.h,
                child: const AnimatedLoader(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
