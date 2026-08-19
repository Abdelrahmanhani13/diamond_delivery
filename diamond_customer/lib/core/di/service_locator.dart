import 'package:diamond_customer/core/settings/settings_cubit.dart';
import 'package:diamond_customer/core/api/api_factory.dart';
import 'package:diamond_customer/core/network/nominatim_client.dart';
import 'package:diamond_customer/features/cart/data/datasource/cart_remote_data_source.dart';
import 'package:diamond_customer/features/cart/data/repos/cart_repo_impl.dart';
import 'package:diamond_customer/features/cart/domain/repos/cart_repo.dart';
import 'package:diamond_customer/features/cart/domain/usecases/cart_use_cases.dart';
import 'package:diamond_customer/features/cart/presentation/controller/cart_cubit.dart';
import 'package:diamond_customer/features/checkout/data/datasource/checkout_remote_data_source.dart';
import 'package:diamond_customer/features/checkout/data/repos/checkout_repo_impl.dart';
import 'package:diamond_customer/features/checkout/domain/repos/checkout_repo.dart';
import 'package:diamond_customer/features/checkout/domain/usecases/get_checkout_use_case.dart';
import 'package:diamond_customer/features/checkout/presentation/controller/checkout_cubit.dart';
import 'package:diamond_customer/features/orders/data/datasource/orders_remote_data_source.dart';
import 'package:diamond_customer/features/orders/data/repos/orders_repo_impl.dart';
import 'package:diamond_customer/features/orders/domain/repos/orders_repo.dart';
import 'package:diamond_customer/features/orders/domain/usecases/orders_use_cases.dart';
import 'package:diamond_customer/features/orders/presentation/controller/orders_cubit.dart';
import 'package:diamond_customer/features/orders/presentation/controller/order_details_cubit.dart';
import 'package:diamond_customer/features/addresses/data/datasource/address_remote_data_source.dart';

import 'package:diamond_customer/features/addresses/data/datasource/location_data_source.dart';
import 'package:diamond_customer/features/addresses/data/repos/address_repo_impl.dart';
import 'package:diamond_customer/features/addresses/data/repos/location_repo_impl.dart';
import 'package:diamond_customer/features/addresses/domain/repos/address_repo_contract.dart';
import 'package:diamond_customer/features/addresses/domain/repos/location_repo_contract.dart';
import 'package:diamond_customer/features/addresses/domain/usecases/add_address_use_case.dart';
import 'package:diamond_customer/features/addresses/domain/usecases/delete_address_use_case.dart';
import 'package:diamond_customer/features/addresses/domain/usecases/get_address_use_case.dart';
import 'package:diamond_customer/features/addresses/domain/usecases/get_current_location_use_case.dart';
import 'package:diamond_customer/features/addresses/domain/usecases/reverse_geocode_use_case.dart';
import 'package:diamond_customer/features/addresses/domain/usecases/search_address_use_case.dart';
import 'package:diamond_customer/features/addresses/domain/usecases/set_default_address_use_case.dart';
import 'package:diamond_customer/features/addresses/domain/usecases/update_address_use_case.dart';
import 'package:diamond_customer/features/addresses/presentation/controller/add_edit_address_cubit/add_edit_address_cubit.dart';
import 'package:diamond_customer/features/addresses/presentation/controller/address_list_cubit/address_list_cubit.dart';
import 'package:diamond_customer/features/addresses/presentation/controller/location_picker_cubit/location_picker_cubit.dart';
import 'package:diamond_customer/features/auth/presentation/controller/cubits/login/login_cubit.dart';
import 'package:diamond_customer/features/auth/presentation/controller/cubits/otp/otp_cubit.dart';
import 'package:diamond_customer/features/auth/presentation/controller/cubits/register/register_cubit.dart';
import 'package:diamond_customer/features/auth/presentation/controller/cubits/reset_password/reset_password_cubit.dart';
import 'package:diamond_customer/features/lookup/data/datasources/lookup_remote_data_source.dart';
import 'package:diamond_customer/features/lookup/data/repos/lookup_repository_impl.dart';
import 'package:diamond_customer/features/lookup/domain/repos/lookup_repository.dart';
import 'package:diamond_customer/features/lookup/domain/usecases/lookup_usecases.dart';
import 'package:diamond_customer/features/lookup/presentation/manager/lookup_cubit.dart';
import 'package:diamond_customer/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:diamond_customer/features/profile/data/repos/profile_repository_impl.dart';
import 'package:diamond_customer/features/profile/domain/repos/profile_repository.dart';
import 'package:diamond_customer/features/profile/domain/usecases/get_profile_use_case.dart';
import 'package:diamond_customer/features/profile/domain/usecases/update_profile_use_case.dart';
import 'package:diamond_customer/features/profile/presentation/controller/profile_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'package:diamond_customer/features/home/data/datasource/home_remote_data_source.dart';
import 'package:diamond_customer/features/home/data/repos/home_repo_impl.dart';
import 'package:diamond_customer/features/home/domain/repos/home_repo.dart';

import 'package:diamond_customer/features/categories/data/datasource/categories_remote_data_source.dart';
import 'package:diamond_customer/features/categories/data/repos/categories_repo_impl.dart';
import 'package:diamond_customer/features/categories/domain/repos/categories_repo.dart';

import 'package:diamond_customer/features/stores/data/datasource/stores_remote_data_source.dart';
import 'package:diamond_customer/features/stores/data/repos/stores_repo_impl.dart';
import 'package:diamond_customer/features/stores/domain/repos/stores_repo.dart';

import 'package:diamond_customer/features/products/data/datasource/products_remote_data_source.dart';
import 'package:diamond_customer/features/products/data/repos/products_repo_impl.dart';
import 'package:diamond_customer/features/products/domain/repos/products_repo.dart';

import 'package:diamond_customer/features/search/data/datasource/search_remote_data_source.dart';
import 'package:diamond_customer/features/search/data/repos/search_repo_impl.dart';
import 'package:diamond_customer/features/search/domain/repos/search_repo.dart';

import 'package:diamond_customer/features/profile/data/datasource/favorites_remote_data_source.dart';
import 'package:diamond_customer/features/profile/data/repos/favorites_repo_impl.dart';
import 'package:diamond_customer/features/profile/domain/repos/favorites_repo.dart';

import 'package:diamond_customer/features/home/domain/usecases/get_home_data_use_case.dart';
import 'package:diamond_customer/features/categories/domain/usecases/get_categories_use_case.dart';
import 'package:diamond_customer/features/stores/domain/usecases/stores_use_cases.dart';
import 'package:diamond_customer/features/products/domain/usecases/products_use_cases.dart';
import 'package:diamond_customer/features/search/domain/usecases/search_use_case.dart';
import 'package:diamond_customer/features/profile/domain/usecases/favorites_use_cases.dart';

import 'package:diamond_customer/features/home/presentation/controller/home_cubit.dart';
import 'package:diamond_customer/features/categories/presentation/controller/categories_cubit.dart';
import 'package:diamond_customer/features/stores/presentation/controller/vendor_list_cubit.dart';
import 'package:diamond_customer/features/stores/presentation/controller/vendor_details_cubit.dart';
import 'package:diamond_customer/features/products/presentation/controller/product_list_cubit.dart';
import 'package:diamond_customer/features/products/presentation/controller/product_details_cubit.dart';
import 'package:diamond_customer/features/search/presentation/controller/search_cubit.dart';
import 'package:diamond_customer/features/profile/presentation/controller/favorites_cubit.dart';
import 'package:diamond_customer/features/auth/domain/repos/auth_repository.dart';
import 'package:diamond_customer/features/auth/auth_event_bus.dart';
import 'package:diamond_customer/features/auth/data/repos/auth_repository_impl.dart';
import 'package:diamond_customer/features/auth/domain/usecases/register_use_case.dart';
import 'package:diamond_customer/features/auth/domain/usecases/request_otp_use_case.dart';
import 'package:diamond_customer/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:diamond_customer/features/auth/domain/usecases/login_use_case.dart';
import 'package:diamond_customer/features/auth/domain/usecases/reset_password_use_case.dart';
import 'package:diamond_customer/features/auth/domain/usecases/logout_use_case.dart';
import 'package:diamond_customer/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:diamond_customer/features/auth/domain/usecases/register_device_use_case.dart';
import 'package:diamond_customer/core/cache/secure_storage_service.dart';
import 'package:diamond_customer/core/api/api_client.dart';
import 'package:diamond_customer/core/network/network_info.dart';
import 'package:diamond_customer/features/auth/domain/usecases/verify_otp_use_case.dart';


final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // External
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  getIt.registerLazySingleton<InternetConnection>(() => InternetConnection());

  // Core Services
  getIt.registerLazySingleton<AuthEventBus>(() => AuthEventBus());
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageServiceImpl(getIt()),
  );

  getIt.registerLazySingleton(
    () => SettingsCubit(getIt()),
  );
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));
  getIt.registerLazySingleton<DioFactory>(() => DioFactory(getIt(), getIt()));
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(getIt<DioFactory>().createDio()),
  );

  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt()),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => VerifyOtpUseCase(getIt()));
  getIt.registerLazySingleton(() => RequestOtpUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => ResetPasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterDeviceUseCase(getIt()));

  // Cubits (Factory registration for fresh state instances)
  getIt.registerFactory(() => LoginCubit(getIt()));
  getIt.registerFactory(() => RegisterCubit(getIt()));
  getIt.registerFactory(() => OtpCubit(getIt(), getIt()));
  getIt.registerFactory(() => ResetPasswordCubit(getIt()));

  // ====================== Addresses Feature ======================

  getIt.registerLazySingleton<NominatimClient>(
    () => NominatimClient(
      userAgent: 'diamond_customer_app',
    ), // أو حسب الـ constructor بتاعه
  );

  // Data Sources
  getIt.registerLazySingleton<AddressRemoteDataSource>(
    () => AddressRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<LocationDataSource>(
    () => LocationDataSourceImpl(getIt()), // هتحتاج تسجل NominatimClient كمان
  );

  // Repositories
  getIt.registerLazySingleton<AddressRepository>(
    () =>
        AddressRepositoryImpl(remoteDataSource: getIt(), networkInfo: getIt()),
  );

  getIt.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(getIt()),
  );

  // Use Cases - Address
  getIt.registerLazySingleton(() => GetAddressesUseCase(getIt()));
  getIt.registerLazySingleton(() => AddAddressUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateAddressUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteAddressUseCase(getIt()));
  getIt.registerLazySingleton(() => SetDefaultAddressUseCase(getIt()));

  // Use Cases - Location
  getIt.registerLazySingleton(() => GetCurrentLocationUseCase(getIt()));
  getIt.registerLazySingleton(() => ReverseGeocodeUseCase(getIt()));
  getIt.registerLazySingleton(() => SearchAddressUseCase(getIt()));

  // Cubits (Factory عشان كل مرة يفتح الشاشة ياخد instance جديد)
  getIt.registerFactory(() => AddressListCubit(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => AddEditAddressCubit(getIt(), getIt()));
  getIt.registerFactory(() => LocationPickerCubit(getIt(), getIt(), getIt()));

  // ====================== Lookup Feature ======================
  // Data Sources
  getIt.registerLazySingleton<LookupRemoteDataSource>(
    () => LookupRemoteDataSourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<LookupRepository>(
    () => LookupRepositoryImpl(remoteDataSource: getIt(), networkInfo: getIt()),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetCountriesUseCase(getIt()));
  getIt.registerLazySingleton(() => GetGovernoratesUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCitiesUseCase(getIt()));

  getIt.registerLazySingleton(() => GetAddressTypesUseCase(getIt()));
  getIt.registerLazySingleton(() => GetGendersUseCase(getIt()));

  // Cubits
  getIt.registerFactory(
    () => LookupCubit(
      getCountriesUseCase: getIt(),
      getGovernoratesUseCase: getIt(),
      getCitiesUseCase: getIt(),

      getAddressTypesUseCase: getIt(),
      getGendersUseCase: getIt(),
    ),
  );

  // ====================== Profile Feature ======================
  // Data Sources
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<ProfileRepository>(
    () =>
        ProfileRepositoryImpl(remoteDataSource: getIt(), networkInfo: getIt()),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetProfileUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateProfileUseCase(getIt()));

  // Cubit
  getIt.registerFactory(() => ProfileCubit(getIt(), getIt()));

  // ====================== Milestone 2 Features ======================

  // Home
  getIt.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(remoteDataSource: getIt(), networkInfo: getIt()));

  // Categories
  getIt.registerLazySingleton<CategoriesRemoteDataSource>(() => CategoriesRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<CategoriesRepo>(() => CategoriesRepoImpl(remoteDataSource: getIt(), networkInfo: getIt()));

  // Stores (Vendors)
  getIt.registerLazySingleton<StoresRemoteDataSource>(() => StoresRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<StoresRepo>(() => StoresRepoImpl(remoteDataSource: getIt(), networkInfo: getIt()));

  // Products
  getIt.registerLazySingleton<ProductsRemoteDataSource>(() => ProductsRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<ProductsRepo>(() => ProductsRepoImpl(remoteDataSource: getIt(), networkInfo: getIt()));

  // Search
  getIt.registerLazySingleton<SearchRemoteDataSource>(() => SearchRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<SearchRepo>(() => SearchRepoImpl(remoteDataSource: getIt(), networkInfo: getIt()));

  // Favorites
  getIt.registerLazySingleton<FavoritesRemoteDataSource>(() => FavoritesRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<FavoritesRepo>(() => FavoritesRepoImpl(remoteDataSource: getIt(), networkInfo: getIt()));

  // Use Cases
  getIt.registerLazySingleton(() => GetHomeDataUseCase(getIt()));
  getIt.registerLazySingleton(() => GetVendorCategoriesUseCase(getIt()));
  
  getIt.registerLazySingleton(() => GetVendorsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetNearbyVendorsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetVendorByIdUseCase(getIt()));
  
  getIt.registerLazySingleton(() => GetProductsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetProductByIdUseCase(getIt()));
  getIt.registerLazySingleton(() => GetRelatedProductsUseCase(getIt()));
  
  getIt.registerLazySingleton(() => SearchUseCase(getIt()));
  
  getIt.registerLazySingleton(() => GetFavoriteVendorsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetFavoriteProductsUseCase(getIt()));
  getIt.registerLazySingleton(() => AddFavoriteVendorUseCase(getIt()));
  getIt.registerLazySingleton(() => RemoveFavoriteVendorUseCase(getIt()));
  getIt.registerLazySingleton(() => AddFavoriteProductUseCase(getIt()));
  getIt.registerLazySingleton(() => RemoveFavoriteProductUseCase(getIt()));

  // Cubits
  getIt.registerFactory(() => HomeCubit(
    getHomeDataUseCase: getIt(),
    getCurrentLocationUseCase: getIt(),
  ));
  getIt.registerFactory(() => CategoriesCubit(getIt()));
  getIt.registerFactory(() => VendorListCubit(getVendorsUseCase: getIt(), getNearbyVendorsUseCase: getIt()));
  getIt.registerFactory(() => VendorDetailsCubit(getIt()));
  getIt.registerFactory(() => ProductListCubit(getIt()));
  getIt.registerFactory(() => ProductDetailsCubit(getProductByIdUseCase: getIt(), getRelatedProductsUseCase: getIt()));
  getIt.registerFactory(() => SearchCubit(getIt()));
  getIt.registerFactory(() => FavoritesCubit(
    getFavoriteVendorsUseCase: getIt(),
    getFavoriteProductsUseCase: getIt(),
    addFavoriteVendorUseCase: getIt(),
    removeFavoriteVendorUseCase: getIt(),
    addFavoriteProductUseCase: getIt(),
    removeFavoriteProductUseCase: getIt(),
  ));

  // ====================== Cart Feature ======================
  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<CartRepo>(
    () => CartRepoImpl(remoteDataSource: getIt(), networkInfo: getIt()),
  );
  getIt.registerLazySingleton(() => GetCartUseCase(getIt()));
  getIt.registerLazySingleton(() => AddToCartUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateCartItemUseCase(getIt()));
  getIt.registerLazySingleton(() => RemoveCartItemUseCase(getIt()));
  getIt.registerLazySingleton(() => ClearCartUseCase(getIt()));
  getIt.registerLazySingleton(
    () => CartCubit(
      getCartUseCase: getIt(),
      addToCartUseCase: getIt(),
      updateCartItemUseCase: getIt(),
      removeCartItemUseCase: getIt(),
      clearCartUseCase: getIt(),
    ),
  );

  // ====================== Checkout Feature ======================
  getIt.registerLazySingleton<CheckoutRemoteDataSource>(
    () => CheckoutRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<CheckoutRepo>(
    () => CheckoutRepoImpl(remoteDataSource: getIt(), networkInfo: getIt()),
  );
  getIt.registerLazySingleton(() => GetCheckoutUseCase(getIt()));
  getIt.registerFactory(
    () => CheckoutCubit(
      getCheckoutUseCase: getIt(),
      createOrderUseCase: getIt(),
    ),
  );

  // ====================== Orders Feature ======================
  getIt.registerLazySingleton<OrdersRemoteDataSource>(
    () => OrdersRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<OrdersRepo>(
    () => OrdersRepoImpl(remoteDataSource: getIt(), networkInfo: getIt()),
  );
  getIt.registerLazySingleton(() => CreateOrderUseCase(getIt()));
  getIt.registerLazySingleton(() => GetOrdersUseCase(getIt()));
  getIt.registerLazySingleton(() => GetOrderByIdUseCase(getIt()));
  getIt.registerLazySingleton(() => CancelOrderUseCase(getIt()));
  getIt.registerFactory(() => OrdersCubit(getOrdersUseCase: getIt()));
  getIt.registerFactory(
    () => OrderDetailsCubit(
      getOrderByIdUseCase: getIt(),
      cancelOrderUseCase: getIt(),
    ),
  );
}

