abstract class ApiConstants {
  // منع الـ instantiation نهائياً
  ApiConstants._();

  static const String baseUrl = 'http://diamonddelivery.runasp.net/api/v1/';

  // ==================== Auth (مشترك) ====================
  static const String register = 'Auth/register';
  static const String login = 'Auth/login';
  static const String requestOtp = 'Auth/otp/request';
  static const String verifyOtp = 'Auth/otp/verify';
  static const String resetPassword = 'Auth/password/reset';
  static const String refreshToken = 'Auth/refresh';
  static const String logout = 'Auth/logout';
  static const String registerDevice = 'Auth/devices';

  // ==================== Address (Customer) ====================
  static const String address = 'Address';
  static String addressById(String id) => '$address/$id';
  static String setDefaultAddress(String id) => '$address/$id/set-default';

  // ==================== Lookup (مشترك) ====================
  static const String lookupGenders = 'Lookup/genders';
  static const String lookupAddressTypes = 'Lookup/address-types';
  static const String lookupCountries = 'Lookup/countries';
  static String lookupGovernorates(String countryId) =>
      'Lookup/countries/$countryId/governorates';
  static String lookupCities(String governorateId) =>
      'Lookup/governorates/$governorateId/cities';

  // ==================== Favorites (Customer) ====================
  static const String favoriteProducts = 'favorites/products';
  static String favoriteProductById(String productId) =>
      '$favoriteProducts/$productId';
  static const String favoriteVendors = 'favorites/vendors';
  static String favoriteVendorById(String vendorId) =>
      '$favoriteVendors/$vendorId';

  // ==================== Products Discovery (Customer) ====================
  static const String products = 'products';
  static String productById(String id) => '$products/$id';
  static String productRelated(String id) => '$products/$id/related';
  static String productImages(String id) => '$products/$id/images';
  static String vendorProductsPublic(String vendorId) =>
      'vendors/$vendorId/products';

  // ==================== Vendor Categories (Customer) ====================
  static const String vendorCategories = 'vendor-categories';

  // ==================== Vendors Discovery (Customer) ====================
  static const String vendors = 'Vendors';
  static String vendorById(String id) => '$vendors/$id';
  static const String nearbyVendors = 'Vendors/nearby';
  static const String searchVendors = 'Vendors/search';

  // ==================== Vendor Profile (Vendor) ====================
  static const String vendorRegister = 'Vendor/register';
  static const String vendorProfile = 'Vendor/profile';
  static const String vendorProfileLogo = 'Vendor/profile/logo';
  static const String vendorProfileCover = 'Vendor/profile/cover';

  // ==================== Vendor Products (Vendor) ====================
  static const String vendorProducts = 'Vendor/products';
  static String vendorProductById(String id) => '$vendorProducts/$id';
  static String vendorProductAvailability(String id) =>
      '$vendorProducts/$id/availability';
  static String vendorProductImages(String id) => '$vendorProducts/$id/images';
  static String vendorProductImageById(String productId, String imageId) =>
      '$vendorProducts/$productId/images/$imageId';
  static String vendorProductImagePrimary(String productId, String imageId) =>
      '$vendorProducts/$productId/images/$imageId/primary';

  // ==================== Admin ====================
  static String adminApproveVendor(String id) => 'Admin/Vendors/$id/approve';
  static String adminRejectVendor(String id) => 'Admin/Vendors/$id/reject';

  // ==================== Cart (Customer) ====================
  static const String cart = 'Cart';
  static const String cartItems = 'Cart/items';
  static String cartItemByProductId(String productId) => '$cartItems/$productId';
  static const String clearCart = 'Cart/clear';

  // ==================== Checkout (Customer) ====================
  static const String checkout = 'Checkout';

  // ==================== Orders (Customer) ====================
  static const String orders = 'Orders';
  static String orderById(String id) => '$orders/$id';
  static String cancelOrder(String id) => '$orders/$id/cancel';


  // ==================== Headers & Config ====================
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';

  static const Duration timeout = Duration(seconds: 30);
}
