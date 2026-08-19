import 'dart:async';

import 'package:diamond_customer/core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:toastification/toastification.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'package:diamond_customer/features/auth/auth_event_bus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setupServiceLocator();
  runApp(const DiamondVillageApp());
}

class DiamondVillageApp extends StatefulWidget {
  const DiamondVillageApp({super.key});

  @override
  State<DiamondVillageApp> createState() => _DiamondVillageAppState();
}

class _DiamondVillageAppState extends State<DiamondVillageApp> {
  late final StreamSubscription<AuthEvent> _authSub;

  @override
  void initState() {
    super.initState();
    // Listen for forced logout events (e.g. refresh token expired)
    _authSub = getIt<AuthEventBus>().stream.listen((event) {
      if (event == AuthEvent.forcedLogout) {
        // Navigate to login and clear the entire back stack
        AppRoutes.router.go(AppRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ToastificationWrapper(
          child: MaterialApp.router(
            title: 'Diamond Village',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            locale: const Locale('ar'),
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: AppRoutes.router,
          ),
        );
      },
    );
  }
}
