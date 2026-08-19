import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vendor_dashboard/features/profile/domain/usecases/vendor_register_usecase.dart';
import 'package:vendor_dashboard/features/auth/presentation/controller/auth_cubit/vendor_auth_cubit.dart';
import 'package:vendor_dashboard/features/auth/presentation/controller/login_cubit/vendor_login_cubit.dart';
import 'package:vendor_dashboard/features/auth/presentation/controller/otp_cubit/vendor_otp_cubit.dart';
import 'package:vendor_dashboard/features/auth/presentation/controller/register_cubit/vendor_register_cubit.dart';
import 'package:vendor_dashboard/features/auth/presentation/controller/reset_password_cubit/vendor_reset_password_cubit.dart';
import 'package:vendor_dashboard/features/products/data/datasources/vendor_products_remote_data_source.dart';
import 'package:vendor_dashboard/features/products/data/repositories/vendor_product_repository_impl.dart';
import 'package:vendor_dashboard/features/products/domain/repositories/vendor_product_repository.dart';
import 'package:vendor_dashboard/features/products/domain/usecases/change_vendor_product_availability.dart';
import 'package:vendor_dashboard/features/products/domain/usecases/create_vendor_product_use_case.dart';
import 'package:vendor_dashboard/features/products/domain/usecases/delete_vendor_product_image_use_case.dart';
import 'package:vendor_dashboard/features/products/domain/usecases/delete_vendor_product_use_case.dart';
import 'package:vendor_dashboard/features/products/domain/usecases/get_vendor_product_by_id_use_case.dart';
import 'package:vendor_dashboard/features/products/domain/usecases/get_vendor_product_use_case.dart';
import 'package:vendor_dashboard/features/products/domain/usecases/set_primary_product_image_use_case.dart';
import 'package:vendor_dashboard/features/products/domain/usecases/update_vendor_product_use_case.dart';
import 'package:vendor_dashboard/features/products/domain/usecases/upload_vendor_product_image_use_case.dart';
import 'package:vendor_dashboard/features/products/presentation/controller/vendor_product_form_cubit/vendor_product_form_cubit.dart';
import 'package:vendor_dashboard/features/products/presentation/controller/vendor_products_cubit/vendor_products_cubit.dart';
import 'package:vendor_dashboard/features/profile/data/datasources/vendor_profile_remote_data_source.dart';
import 'package:vendor_dashboard/features/profile/data/repositories/vendor_profile_repository_impl.dart';
import 'package:vendor_dashboard/features/profile/domain/repositories/vendor_profile_repository.dart';
import 'package:vendor_dashboard/features/profile/domain/usecases/vendor_get_profile_use_case.dart';
import 'package:vendor_dashboard/features/profile/domain/usecases/vendor_update_profile_use_case.dart';
import 'package:vendor_dashboard/features/profile/domain/usecases/vendor_upload_cover_use_case.dart';
import 'package:vendor_dashboard/features/profile/domain/usecases/vendor_upload_logo_use_case.dart';
import 'package:vendor_dashboard/features/profile/presentation/controller/profile_cubit/vendor_profile_cubit.dart';
import 'package:vendor_dashboard/core/network/nominatim_client.dart';
import 'package:vendor_dashboard/features/addresses/data/datasource/location_data_source.dart';
import 'package:vendor_dashboard/features/addresses/data/repos/location_repo_impl.dart';
import 'package:vendor_dashboard/features/addresses/domain/repos/location_repo_contract.dart';
import 'package:vendor_dashboard/features/addresses/domain/usecases/get_current_location_use_case.dart';
import 'package:vendor_dashboard/features/addresses/domain/usecases/reverse_geocode_use_case.dart';
import 'package:vendor_dashboard/features/addresses/domain/usecases/search_address_use_case.dart';
import 'package:vendor_dashboard/features/addresses/presentation/controller/location_picker_cubit/location_picker_cubit.dart';
import 'package:vendor_dashboard/features/auth/data/datasources/vendor_auth_remote_data_source.dart';
import 'package:vendor_dashboard/features/auth/domain/usecases/vendor_reset_password_usecase.dart';
import 'package:vendor_dashboard/features/auth/domain/usecases/vendor_request_otp_usecase.dart';
import 'package:vendor_dashboard/features/auth/domain/usecases/vendor_login_usecase.dart';
import 'package:vendor_dashboard/core/api/api_client.dart';
import 'package:vendor_dashboard/core/cache/secure_storage_service.dart';
import 'package:vendor_dashboard/features/auth/domain/usecases/vendor_register_device_usecase.dart';
import 'package:vendor_dashboard/features/auth/data/datasources/vendor_auth_local_data_source.dart';
import 'package:vendor_dashboard/core/network/auth_event_bus.dart';
import 'package:vendor_dashboard/features/auth/domain/repositories/vendor_auth_repository.dart';
import 'package:vendor_dashboard/features/auth/domain/usecases/vendor_logout_usecase.dart';
import 'package:vendor_dashboard/features/auth/domain/usecases/vendor_verify_otp_usecase.dart';
final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ==========================================
  // 1. Core & External Services
  // ==========================================
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageServiceImpl(getIt<FlutterSecureStorage>()),
  );

  getIt.registerLazySingleton<AuthEventBus>(() => AuthEventBus());

  getIt.registerLazySingleton<DioFactory>(
    () => DioFactory(getIt<SecureStorageService>(), getIt<AuthEventBus>()),
  );

  getIt.registerLazySingleton<Dio>(() => getIt<DioFactory>().createDio());

  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt<Dio>()));

  // ==========================================
  // 2. Data Sources
  // ==========================================
  getIt.registerLazySingleton<VendorAuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      secureStorageService: getIt<SecureStorageService>(),
    ),
  );

  getIt.registerLazySingleton<VendorAuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  // ==========================================
  // 3. Repositories
  // ==========================================
  getIt.registerLazySingleton<VendorAuthRepository>(
    () => AuthRepositoryImpl(
      getIt<VendorAuthRemoteDataSource>(),
      getIt<VendorAuthLocalDataSource>(),
    ),
  );

  // ==========================================
  // 4. Use Cases
  // ==========================================
  getIt.registerLazySingleton<VendorLoginUseCase>(
    () => VendorLoginUseCase(getIt<VendorAuthRepository>()),
  );

  getIt.registerLazySingleton<VendorLogoutUseCase>(
    () => VendorLogoutUseCase(getIt<VendorAuthRepository>()),
  );

  getIt.registerLazySingleton<VendorRefreshTokenUseCase>(
    () => VendorRefreshTokenUseCase(getIt<VendorAuthRepository>()),
  );

  getIt.registerLazySingleton<VendorRegisterDeviceUseCase>(
    () => VendorRegisterDeviceUseCase(getIt<VendorAuthRepository>()),
  );

  getIt.registerLazySingleton<VendorRegisterUseCase>(
    () => VendorRegisterUseCase(getIt<VendorAuthRepository>()),
  );

  getIt.registerLazySingleton<VendorRequestOtpUseCase>(
    () => VendorRequestOtpUseCase(getIt<VendorAuthRepository>()),
  );

  getIt.registerLazySingleton<VendorResetPasswordUseCase>(
    () => VendorResetPasswordUseCase(getIt<VendorAuthRepository>()),
  );

  getIt.registerLazySingleton<VendorVerifyOtpUseCase>(
    () => VendorVerifyOtpUseCase(getIt<VendorAuthRepository>()),
  );

  // ==========================================
  // 5. Cubits (Factory كي تُنشأ instance جديدة مع كل شاشة)
  // ==========================================
  getIt.registerFactory<VendorAuthCubit>(
    () => VendorAuthCubit(localDataSource: getIt<VendorAuthLocalDataSource>()),
  );

  getIt.registerFactory<VendorLoginCubit>(
    () => VendorLoginCubit(loginUseCase: getIt<VendorLoginUseCase>()),
  );

  getIt.registerFactory<VendorOtpCubit>(
    () => VendorOtpCubit(
      requestOtpUseCase: getIt<VendorRequestOtpUseCase>(),
      verifyOtpUseCase: getIt<VendorVerifyOtpUseCase>(),
    ),
  );

  getIt.registerFactory<VendorRegisterCubit>(
    () => VendorRegisterCubit(registerUseCase: getIt<VendorRegisterUseCase>()),
  );

  getIt.registerFactory<VendorResetPasswordCubit>(
    () => VendorResetPasswordCubit(
      resetPasswordUseCase: getIt<VendorResetPasswordUseCase>(),
    ),
  );

  getIt.registerLazySingleton<VendorProfileRemoteDataSource>(
    () => VendorProfileRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<VendorProfileRepository>(
    () => VendorProfileRepositoryImpl(getIt<VendorProfileRemoteDataSource>()),
  );

  // 6. Products Feature
  // ==========================================
  getIt.registerLazySingleton<VendorProductRemoteDataSource>(
    () => VendorProductRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<VendorProductRepository>(
    () => VendorProductRepositoryImpl(getIt<VendorProductRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetVendorProductsUseCase>(
    () => GetVendorProductsUseCase(getIt<VendorProductRepository>()),
  );
  getIt.registerLazySingleton<GetVendorProductByIdUseCase>(
    () => GetVendorProductByIdUseCase(getIt<VendorProductRepository>()),
  );
  getIt.registerLazySingleton<CreateVendorProductUseCase>(
    () => CreateVendorProductUseCase(getIt<VendorProductRepository>()),
  );
  getIt.registerLazySingleton<UpdateVendorProductUseCase>(
    () => UpdateVendorProductUseCase(getIt<VendorProductRepository>()),
  );
  getIt.registerLazySingleton<DeleteVendorProductUseCase>(
    () => DeleteVendorProductUseCase(getIt<VendorProductRepository>()),
  );
  getIt.registerLazySingleton<ChangeVendorProductAvailabilityUseCase>(
    () => ChangeVendorProductAvailabilityUseCase(
      getIt<VendorProductRepository>(),
    ),
  );
  getIt.registerLazySingleton<UploadVendorProductImageUseCase>(
    () => UploadVendorProductImageUseCase(getIt<VendorProductRepository>()),
  );
  getIt.registerLazySingleton<DeleteVendorProductImageUseCase>(
    () => DeleteVendorProductImageUseCase(getIt<VendorProductRepository>()),
  );
  getIt.registerLazySingleton<SetPrimaryVendorProductImageUseCase>(
    () => SetPrimaryVendorProductImageUseCase(getIt<VendorProductRepository>()),
  );

  getIt.registerLazySingleton<VendorGetProfileUseCase>(
    () => VendorGetProfileUseCase(getIt<VendorProfileRepository>()),
  );

  getIt.registerLazySingleton<VendorUpdateProfileUseCase>(
    () => VendorUpdateProfileUseCase(getIt<VendorProfileRepository>()),
  );

  getIt.registerLazySingleton<VendorUploadLogoUseCase>(
    () => VendorUploadLogoUseCase(getIt<VendorProfileRepository>()),
  );

  getIt.registerLazySingleton<VendorUploadCoverUseCase>(
    () => VendorUploadCoverUseCase(getIt<VendorProfileRepository>()),
  );

  getIt.registerFactory<VendorProductsCubit>(
    () => VendorProductsCubit(
      getProductsUseCase: getIt<GetVendorProductsUseCase>(),
      changeAvailabilityUseCase:
          getIt<ChangeVendorProductAvailabilityUseCase>(),
      deleteProductUseCase: getIt<DeleteVendorProductUseCase>(),
    ),
  );

  getIt.registerFactory<VendorProductFormCubit>(
    () => VendorProductFormCubit(
      createProductUseCase: getIt<CreateVendorProductUseCase>(),
      updateProductUseCase: getIt<UpdateVendorProductUseCase>(),
      uploadImageUseCase: getIt<UploadVendorProductImageUseCase>(),
      deleteImageUseCase: getIt<DeleteVendorProductImageUseCase>(),
      setPrimaryImageUseCase: getIt<SetPrimaryVendorProductImageUseCase>(),
    ),
  );

  getIt.registerFactory<VendorProfileCubit>(
    () => VendorProfileCubit(
      getProfileUseCase: getIt<VendorGetProfileUseCase>(),
      updateProfileUseCase: getIt<VendorUpdateProfileUseCase>(),
      uploadLogoUseCase: getIt<VendorUploadLogoUseCase>(),
      uploadCoverUseCase: getIt<VendorUploadCoverUseCase>(),
    ),
  );

  // ==========================================
  // 7. Location & Addresses Feature
  // ==========================================
  getIt.registerLazySingleton<NominatimClient>(
    () => NominatimClient(userAgent: 'com.diamondvillage.vendor'),
  );

  getIt.registerLazySingleton<LocationDataSource>(
    () => LocationDataSourceImpl(getIt<NominatimClient>()),
  );

  getIt.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(getIt<LocationDataSource>()),
  );

  getIt.registerLazySingleton<GetCurrentLocationUseCase>(
    () => GetCurrentLocationUseCase(getIt<LocationRepository>()),
  );

  getIt.registerLazySingleton<ReverseGeocodeUseCase>(
    () => ReverseGeocodeUseCase(getIt<LocationRepository>()),
  );

  getIt.registerLazySingleton<SearchAddressUseCase>(
    () => SearchAddressUseCase(getIt<LocationRepository>()),
  );

  getIt.registerFactory<LocationPickerCubit>(
    () => LocationPickerCubit(
      getIt<GetCurrentLocationUseCase>(),
      getIt<ReverseGeocodeUseCase>(),
      getIt<SearchAddressUseCase>(),
    ),
  );
}
