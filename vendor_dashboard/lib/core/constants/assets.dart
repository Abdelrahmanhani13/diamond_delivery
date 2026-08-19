/// Asset accessor for Diamond Village Customer App.
/// Always reference paths through this class — never hardcode asset strings.
class Assets {
  Assets._();

  static const images = _Images();
  static const icons = _Icons();
  static const lottie = _Lottie();
}

class _Images {
  const _Images();

  /// Brand logo / splash illustration (SVG).
  String get logo => 'assets/images/delivery food splash.svg';

  /// Splash background hero.
  String get splashHero => 'assets/images/delivery food splash.svg';

  /// Promo / banner placeholder.
  String get promoBanner => 'assets/images/pexels-cottonbro-6865182.jpg';

  /// Empty-state illustrations.
  String get noInternet => 'assets/images/delivery food splash.svg';
  String get emptyBox => 'assets/images/delivery food splash.svg';
  String get orderSuccess => 'assets/images/delivery food splash.svg';
  String get orderFailed => 'assets/images/delivery food splash.svg';
  String get avatarPlaceholder => 'assets/images/OIP.webp';

  /// Category / store / product placeholders.
  String get categoryRestaurants =>
      'assets/images/amirali-mirhashemian-jh5XyK4Rr3Y-unsplash.jpg';
  String get categoryGrocery => 'assets/images/pexels-cottonbro-6865182.jpg';
  String get categoryPharmacy => 'assets/images/delivery food splash.svg';
  String get storeImage =>
      'assets/images/amirali-mirhashemian-jh5XyK4Rr3Y-unsplash.jpg';
  String get productImage =>
      'assets/images/amirali-mirhashemian-jh5XyK4Rr3Y-unsplash.jpg';
}

class _Icons {
  const _Icons();

  String get search => 'assets/icons/search.svg';
  String get cart => 'assets/icons/cart.svg';
  String get home => 'assets/icons/home.svg';
  String get profile => 'assets/icons/profile.svg';
  String get orders => 'assets/icons/orders.svg';
  String get notification => 'assets/icons/notification.svg';
  String get location => 'assets/icons/location.svg';
  String get wallet => 'assets/icons/wallet.svg';
  String get favorite => 'assets/icons/favorite.svg';
  String get categories => 'assets/icons/categories.svg';
  String get settings => 'assets/icons/settings.svg';
  String get logout => 'assets/icons/logout.svg';
  String get pharmacy => 'assets/icons/pharmacy.svg';
  String get burger => 'assets/icons/burger.svg';
  String get grocery => 'assets/icons/grocery.svg';
  String get flower => 'assets/icons/flower.svg';
  String get electronics => 'assets/icons/electronics.svg';
}

class _Lottie {
  const _Lottie();

  /// Looping hero animation for onboarding.
  String get onboardingDelivery => 'assets/lottie/delivery food splash.json';
}
