import 'package:diamond_customer/features/checkout/presentation/views/checkout_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/service_locator.dart';
import '../../features/home/presentation/controller/home_cubit.dart';
import '../../features/categories/presentation/controller/categories_cubit.dart';
import '../../features/stores/presentation/controller/vendor_list_cubit.dart';
import '../../features/stores/presentation/controller/vendor_details_cubit.dart';
import '../../features/products/presentation/controller/product_list_cubit.dart';
import '../../features/products/presentation/controller/product_details_cubit.dart';
import '../../features/search/presentation/controller/search_cubit.dart';
import '../../features/profile/presentation/controller/favorites_cubit.dart';
import '../../features/profile/presentation/views/favorites_view.dart';

import '../../features/splash/presentation/views/splash_view.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/register_view.dart';
import '../../features/auth/presentation/views/forgot_password_view.dart';
import '../../features/auth/presentation/views/otp_verification_view.dart';
import '../../features/auth/presentation/views/reset_password_view.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/home/presentation/views/categories_view.dart';
import '../../features/search/presentation/views/search_view.dart';
import '../../features/orders/presentation/views/orders_view.dart';
import '../../features/orders/presentation/views/order_details_view.dart';
import '../../features/orders/presentation/views/order_tracking_view.dart';
import '../../features/orders/presentation/views/rate_order_view.dart';
import '../../features/orders/presentation/views/rate_driver_view.dart';
import '../../features/orders/presentation/views/leave_review_view.dart';
import '../../features/orders/presentation/views/download_invoice_view.dart';
import '../../features/orders/presentation/views/report_problem_view.dart';
import '../../features/orders/presentation/views/contact_support_view.dart';
import '../../features/cart/presentation/views/cart_view.dart';
import '../../features/notifications/presentation/views/notifications_view.dart';
import '../../features/profile/presentation/views/profile_view.dart';
import '../../features/order_result/presentation/views/order_success_view.dart';
import '../../features/order_result/presentation/views/order_failed_view.dart';
import '../../features/order_result/presentation/views/payment_failed_view.dart';
import '../../features/order_result/presentation/views/order_cancelled_view.dart';
import '../../features/products/presentation/views/product_details_view.dart';
import '../../features/products/presentation/views/products_list_view.dart';
import '../../features/stores/presentation/views/stores_list_view.dart';
import '../../features/checkout/presentation/views/review_order_view.dart';
import '../../features/addresses/presentation/views/address_list_view.dart';
import '../../features/addresses/presentation/views/add_edit_address_view.dart';
import '../../features/addresses/presentation/views/location_picker_view.dart';
import '../../features/addresses/domain/entities/address_domain_entity.dart';
import '../../core/widgets/loading_widget.dart';

/// Central route table managed by GoRouter.
class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const otpVerification = '/otp-verification';
  static const resetPassword = '/reset-password';
  static const home = '/home';
  static const categories = '/categories';
  static const search = '/search';
  static const orders = '/orders';
  static const orderDetails = '/order-details';
  static const orderTracking = '/order-tracking';
  static const rateOrder = '/rate-order';
  static const rateDriver = '/rate-driver';
  static const leaveReview = '/leave-review';
  static const downloadInvoice = '/download-invoice';
  static const reportProblem = '/report-problem';
  static const String profile = '/profile';
  static const String favorites = '/favorites';
  static const String contactSupport = '/contact-support';
  static const cart = '/cart';
  static const notifications = '/notifications';
  static const orderSuccess = '/order-success';
  static const orderFailed = '/order-failed';
  static const paymentFailed = '/payment-failed';
  static const orderCancelled = '/order-cancelled';
  static const productDetails = '/product-details';
  static const productsList = '/products-list';
  static const storesList = '/stores-list';
  static const checkout = '/checkout';
  static const reviewOrder = '/review-order';
  static const addressList = '/address-list';
  static const addAddress = '/add-address';
  static const editAddress = '/edit-address';
  static const locationPicker = '/location-picker';
  static const noInternet = '/no-internet';
  static const loading = '/loading';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashView()),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(path: login, builder: (context, state) => const LoginView()),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: forgotPassword,
        builder: (context, state) => const ForgotPasswordView(),
      ),
      GoRoute(
        path: otpVerification,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? const {};
          return OtpVerificationView(
            phoneNumber: extra['phoneNumber'] as String? ?? '',
            isPasswordReset: extra['isPasswordReset'] as bool? ?? false,
          );
        },
      ),
      GoRoute(
        path: resetPassword,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? const {};
          return ResetPasswordView(
            email: extra['phoneNumber'] as String? ?? '',
            otp: extra['otp'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: home,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<HomeCubit>()..fetchHomeData(),
          child: const HomeView(),
        ),
      ),
      GoRoute(
        path: categories,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              getIt<CategoriesCubit>()..fetchVendorCategories(),
          child: const CategoriesView(),
        ),
      ),
      GoRoute(
        path: search,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<SearchCubit>(),
          child: const SearchView(),
        ),
      ),
      GoRoute(path: orders, builder: (context, state) => const OrdersView()),
      GoRoute(
        path: orderDetails,
        builder: (context, state) {
          final orderId = state.extra as String?;
          return OrderDetailsView(orderId: orderId);
        },
      ),
      GoRoute(
        path: orderTracking,
        builder: (context, state) => const OrderTrackingView(),
      ),
      GoRoute(
        path: rateOrder,
        builder: (context, state) => const RateOrderView(),
      ),
      GoRoute(
        path: rateDriver,
        builder: (context, state) => const RateDriverView(),
      ),
      GoRoute(
        path: leaveReview,
        builder: (context, state) => const LeaveReviewView(),
      ),
      GoRoute(
        path: downloadInvoice,
        builder: (context, state) => const DownloadInvoiceView(),
      ),
      GoRoute(
        path: reportProblem,
        builder: (context, state) => const ReportProblemView(),
      ),
      GoRoute(
        path: favorites,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<FavoritesCubit>()
            ..fetchFavoriteVendors(refresh: true)
            ..fetchFavoriteProducts(refresh: true),
          child: const FavoritesView(),
        ),
      ),
      GoRoute(
        path: contactSupport,
        builder: (context, state) => const ContactSupportView(),
      ),
      GoRoute(path: cart, builder: (context, state) => const CartView()),
      GoRoute(
        path: notifications,
        builder: (context, state) => const NotificationsView(),
      ),
      GoRoute(path: profile, builder: (context, state) => const ProfileView()),
      GoRoute(
        path: orderSuccess,
        builder: (context, state) => const OrderSuccessView(),
      ),
      GoRoute(
        path: orderFailed,
        builder: (context, state) => const OrderFailedView(),
      ),
      GoRoute(
        path: paymentFailed,
        builder: (context, state) => const PaymentFailedView(),
      ),
      GoRoute(
        path: orderCancelled,
        builder: (context, state) => const OrderCancelledView(),
      ),
      GoRoute(
        path: productDetails,
        builder: (context, state) {
          final productId = state.extra as String?;
          if (productId == null) {
            return const Scaffold(
              body: Center(child: Text('Error: No product ID')),
            );
          }

          return BlocProvider(
            create: (context) =>
                getIt<ProductDetailsCubit>()..fetchProductDetails(productId),
            child: const ProductDetailsView(),
          );
        },
      ),
      GoRoute(
        path: productsList,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final vendorId = extra?['vendorId'] as String?;
          final vendorName = extra?['vendorName'] as String?;

          return MultiBlocProvider(
            providers: [
              if (vendorId != null)
                BlocProvider(
                  create: (context) =>
                      getIt<VendorDetailsCubit>()..fetchVendorDetails(vendorId),
                ),
              BlocProvider(
                create: (context) =>
                    getIt<ProductListCubit>()
                      ..fetchProducts(refresh: true, vendorId: vendorId),
              ),
            ],
            child: ProductsListView(
              vendorId: vendorId,
              vendorName: vendorName ?? 'المتجر',
            ),
          );
        },
      ),
      GoRoute(
        path: storesList,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final categoryId = extra?['categoryId'] as String?;
          final search = extra?['search'] as String?;

          return BlocProvider(
            create: (context) => getIt<VendorListCubit>()
              ..fetchVendors(
                refresh: true,
                categoryId: categoryId,
                search: search,
              ),
            child: StoresListView(
              categoryTitle: extra?['categoryTitle'] as String? ?? 'متاجر',
            ),
          );
        },
      ),
      GoRoute(
        path: checkout,
        builder: (context, state) => const CheckoutView(),
      ),
      GoRoute(
        path: reviewOrder,
        builder: (context, state) => const ReviewOrderView(),
      ),
      GoRoute(
        path: addressList,
        builder: (context, state) => const AddressListView(),
      ),
      GoRoute(
        path: addAddress,
        builder: (context, state) => const AddEditAddressView(),
      ),
      GoRoute(
        path: editAddress,
        builder: (context, state) {
          final address = state.extra as Address?;
          return AddEditAddressView(isEditing: true, address: address);
        },
      ),
      GoRoute(
        path: locationPicker,
        builder: (context, state) => const LocationPickerView(),
      ),
      // GoRoute(
      //   path: noInternet,
      //   builder: (context, state) => const NoInternetWidget(),
      // ),
      GoRoute(
        path: loading,
        builder: (context, state) => const LoadingWidget(),
      ),
    ],
  );
}
