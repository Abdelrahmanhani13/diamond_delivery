import 'dart:async';

import 'package:diamond_customer/core/di/service_locator.dart';
import 'package:diamond_customer/core/localization/app_localizations.dart';
import 'package:diamond_customer/core/settings/settings_cubit.dart';
import 'package:diamond_customer/core/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocProvider(
      create: (_) => getIt<SettingsCubit>(),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return ToastificationWrapper(
            child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, settingsState) {
                return MaterialApp.router(
                  title: 'Diamond Village',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,
                  themeMode: settingsState.themeMode,
                  locale: settingsState.locale,
                  supportedLocales: const [Locale('ar'), Locale('en')],
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  routerConfig: AppRoutes.router,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
