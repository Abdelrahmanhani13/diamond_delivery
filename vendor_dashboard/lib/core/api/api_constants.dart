class ApiConstants {
  static const String baseUrl = 'http://diamonddelivery.runasp.net/api/v1';
  static const Duration timeout = Duration(seconds: 30);
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';

  // ── Auth Endpoints ─────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String requestOtp = '/auth/request-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';
  static const String resetPassword = '/auth/reset-password';
  static const String registerDevice = '/auth/register-device';

  // ── Vendor Category API ──────────────────────────────
  static const String vendorCategories = '/vendor-categories';

  // ── Vendor Orders Endpoints ─────────────────────────
  static const String vendorOrders = '/vendor/orders';
  static String vendorOrderById(String id) => '/vendor/orders/$id';
  static String vendorOrderAccept(String id) => '/vendor/orders/$id/accept';
  static String vendorOrderReject(String id) => '/vendor/orders/$id/reject';
  static String vendorOrderPreparing(String id) =>
      '/vendor/orders/$id/preparing';
  static String vendorOrderReady(String id) => '/vendor/orders/$id/ready';

  // ── Vendor Products Endpoints ─────────────────────────
  static const String vendorProducts = '/Vendor/products';
  static String vendorProductById(String id) => '/Vendor/products/$id';
  static String vendorProductAvailability(String id) =>
      '/Vendor/products/$id/availability';

  // ── Vendor Product Images Endpoints ──────────────────
  static String vendorProductImages(String productId) =>
      '/Vendor/products/$productId/images';
  static String vendorProductImageById(String productId, String imageId) =>
      '/Vendor/products/$productId/images/$imageId';
  static String vendorProductImagePrimary(String productId, String imageId) =>
      '/Vendor/products/$productId/images/$imageId/primary';

  // ── Vendor Registration, Profile & Dashboard Endpoints
  static const String vendorRegister = '/Vendor/register';
  static const String vendorProfile = '/Vendor/profile';
  static const String vendorDashboard = '/Vendor/dashboard';
  static const String vendorOpenStatus = '/Vendor/open-status';
  static const String vendorProfileLogo = '/Vendor/profile/logo';
  static const String vendorProfileCover = '/Vendor/profile/cover';
}

typedef AuthApiConstants = ApiConstants;
