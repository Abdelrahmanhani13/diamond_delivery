import 'package:vendor_dashboard/features/auth/data/datasources/vendor_auth_local_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/di/service_locator.dart';
import 'core/theme/vendor_theme.dart';
import 'core/routes/app_router.dart';
import 'core/services/snackbar_service.dart';
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

  @override
  void initState() {
    super.initState();
    _authCubit = getIt<VendorAuthCubit>()..checkAuthStatus();
    _appRouter = AppRouter(authCubit: _authCubit);
  }

  @override
  void dispose() {
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VendorAuthCubit>.value(
      value: _authCubit,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            title: 'Diamond Village - Vendor Dashboard',
            debugShowCheckedModeBanner: false,
            theme: VendorTheme.lightTheme,
            scaffoldMessengerKey: scaffoldMessengerKey,
            routerConfig: _appRouter.router,
          );
        },
      ),
    );
  }
}
