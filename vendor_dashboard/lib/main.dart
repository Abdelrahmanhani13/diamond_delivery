import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/di/service_locator.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/language_cubit.dart';
import 'core/localization/language_state.dart';
import 'core/routes/app_router.dart';
import 'core/services/snackbar_service.dart';
import 'core/theme/vendor_theme.dart';
import 'features/auth/presentation/controller/auth_cubit/vendor_auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const VendorDashboardApp());
}

class VendorDashboardApp extends StatefulWidget {
  const VendorDashboardApp({super.key});

  @override
  State<VendorDashboardApp> createState() => _VendorDashboardAppState();
}

class _VendorDashboardAppState extends State<VendorDashboardApp> {
  late final VendorAuthCubit _authCubit;
  late final AppRouter _appRouter;
  late final LanguageCubit _languageCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = getIt<VendorAuthCubit>()..checkAuthStatus();
    _languageCubit = getIt<LanguageCubit>();
    _appRouter = AppRouter(authCubit: _authCubit);
  }

  @override
  void dispose() {
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VendorAuthCubit>.value(value: _authCubit),
        BlocProvider<LanguageCubit>.value(value: _languageCubit),
      ],
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, languageState) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp.router(
                title: 'Diamond Village - Vendor Dashboard',
                debugShowCheckedModeBanner: false,
                theme: VendorTheme.lightTheme,
                scaffoldMessengerKey: scaffoldMessengerKey,
                locale: languageState.locale,
                supportedLocales: const [Locale('ar'), Locale('en')],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                routerConfig: _appRouter.router,
              );
            },
          );
        },
      ),
    );
  }
}
