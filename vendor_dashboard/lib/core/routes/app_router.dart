import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/controller/auth_cubit/vendor_auth_cubit.dart';
import '../../features/auth/presentation/controller/auth_cubit/vendor_auth_state.dart';

// Import Pages
import '../../features/auth/presentation/pages/vendor_login_page.dart';
import '../../features/auth/presentation/pages/vendor_register_page.dart';
import '../../features/auth/presentation/pages/vendor_otp_page.dart';
import '../../features/auth/presentation/pages/vendor_reset_password_page.dart';
import '../../features/core_ui/presentation/pages/vendor_dashboard_page.dart';
import '../../features/products/presentation/pages/vendor_add_edit_product_page.dart';
import '../../features/profile/presentation/pages/vendor_edit_profile_page.dart';
import '../../features/products/domain/entities/vendor_product.dart';
import '../../features/profile/domain/entities/vendor_profile.dart';
import '../../features/addresses/presentation/views/location_picker_view.dart';

/// Centralized route path constants.
/// Use these everywhere instead of hardcoded strings.
class RoutePaths {
  static const login = '/login';
  static const register = '/register';
  static const resetPassword = '/reset-password';
  static const otp = '/otp';
  static const dashboard = '/dashboard';
  static const productAddEdit = '/products/add-edit';
  static const profileEdit = '/profile/edit';
  static const profileSetup = '/profile-setup';
  static const locationPicker = '/location-picker';
}

class AppRouter {
  final VendorAuthCubit authCubit;

  AppRouter({required this.authCubit});

  /// Set of paths that are considered "auth" screens.
  static const _authPaths = {
    RoutePaths.login,
    RoutePaths.register,
    RoutePaths.resetPassword,
    RoutePaths.otp,
  };

  late final GoRouter router = GoRouter(
    initialLocation: RoutePaths.dashboard,
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (BuildContext context, GoRouterState state) {
      final isAuth = authCubit.state is VendorAuthenticated;
      final isGoingToAuth = _authPaths.contains(state.matchedLocation);
      final isPublic = state.matchedLocation == RoutePaths.locationPicker;

      if (isPublic) return null; // Prevent redirecting location picker

      // Not authenticated & not heading to an auth page → force login.
      if (!isAuth && !isGoingToAuth) return RoutePaths.login;

      // Already authenticated & heading to an auth page → go to dashboard.
      if (isAuth && isGoingToAuth) return RoutePaths.dashboard;

      return null; // no redirect
    },
    routes: [
      // ─── Auth ──────────────────────────────────────
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const VendorLoginPage(),
      ),
      GoRoute(
        path: RoutePaths.register,
        builder: (context, state) => const VendorRegisterPage(),
      ),
      GoRoute(
        path: RoutePaths.resetPassword,
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return VendorResetPasswordPage(email: email);
        },
      ),
      GoRoute(
        path: RoutePaths.otp,
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return VendorOtpPage(email: email);
        },
      ),

      // ─── App ───────────────────────────────────────
      GoRoute(
        path: RoutePaths.dashboard,
        builder: (context, state) => const VendorDashboardPage(),
      ),
      GoRoute(
        path: RoutePaths.productAddEdit,
        builder: (context, state) {
          final product = state.extra as VendorProduct?;
          return VendorAddEditProductPage(product: product);
        },
      ),
      GoRoute(
        path: RoutePaths.profileEdit,
        builder: (context, state) {
          final profile = state.extra as VendorProfile;
          return VendorEditProfilePage(profile: profile);
        },
      ),
      // GoRoute(
      //   path: RoutePaths.profileSetup,
      //   builder: (context, state) => const VendorProfileSetupPage(),
      // ),
      GoRoute(
        path: RoutePaths.locationPicker,
        builder: (context, state) => const LocationPickerView(),
      ),
    ],
  );
}

/// Converts a [Stream] into a [ChangeNotifier] so GoRouter can
/// listen for auth state changes and re-evaluate its redirect.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
