import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('ar'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  bool get isArabic => locale.languageCode == 'ar';

  static final Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      // App & Navigation
      'appTitle': 'لوحة تحكم البائع - Diamond Delivery',
      'dashboard': 'الرئيسية',
      'orders': 'الطلبات',
      'products': 'المنتجات',
      'profile': 'الملف الشخصي',
      'settings': 'الإعدادات',
      'language': 'اللغة',
      'arabic': 'العربية',
      'english': 'English',
      'changeLanguage': 'تغيير اللغة',

      // General Buttons & Actions
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'confirm': 'تأكيد',
      'refresh': 'تحديث',
      'retry': 'إعادة المحاولة',
      'logout': 'تسجيل الخروج',
      'edit': 'تعديل',
      'delete': 'حذف',
      'back': 'رجوع',
      'add': 'إضافة',
      'submit': 'إرسال',
      'saveChanges': 'حفظ التعديلات',
      'search': 'بحث',

      // Vendor Registration
      'registerTitle': 'تسجيل بائع جديد',
      'registerSubtitle': 'أدخل بيانات المتجر وموقعه للبدء في البيع',
      'createStoreHeader': 'أنشئ متجرك الآن',
      'businessInfoSection': 'معلومات النشاط التجاري',
      'selectCategory': 'اختر نوع النشاط التجاري',
      'selectCategoryHint': 'اضغط لاختيار فئة المتجر',
      'storeName': 'اسم المتجر',
      'storeNameHint': 'أدخل اسم المتجر',
      'storeDescription': 'وصف المتجر (اختياري)',
      'storeDescriptionHint': 'أدخل وصف مختصر للخدمات والمنتجات',
      'bilingualOptions': 'بيانات باللغة الإنجليزية (اختياري)',
      'storeNameEn': 'اسم المتجر بالإنجليزية',
      'storeDescriptionEn': 'وصف المتجر بالإنجليزية',
      'contactInfoSection': 'بيانات التواصل',
      'phoneNumber': 'رقم الجوال',
      'whatsappNumber': 'رقم الواتساب (اختياري)',
      'emailAddress': 'البريد الإلكتروني (اختياري)',
      'locationSection': 'موقع المتجر',
      'pickLocationOnMap': 'اضغط لتحديد موقع المتجر على الخريطة',
      'locationSelected': 'تم تحديد الموقع بنجاح',
      'displayAddress': 'العنوان الظاهر',
      'financialsSection': 'التوصيل والطلبات',
      'deliveryFee': 'رسوم التوصيل (د.أ)',
      'minimumOrder': 'الحد الأدنى للطلب (د.أ)',
      'confirmAndRegister': 'تأكيد وإنشاء المتجر',
      'registrationSuccess': 'تم تسجيل المتجر بنجاح',
      'selectLocationFirst': 'يرجى تحديد موقع المتجر على الخريطة أولاً',
      'selectCategoryFirst': 'يرجى اختيار نوع النشاط التجاري',

      // Form Validation Messages
      'fieldRequired': 'هذا الحقل مطلوب',
      'invalidPhone': 'يرجى أدخال رقم جوال صحيح',
      'invalidEmail': 'يرجى إدخال بريد إلكتروني صحيح',
      'invalidNumber': 'يرجى إدخال رقم صحيح',

      // Dashboard & Profile
      'storeStats': 'إحصائيات المتجر',
      'totalProducts': 'إجمالي المنتجات',
      'newOrders': 'الطلبات الجديدة',
      'preparingOrders': 'قيد التجهيز',
      'readyOrders': 'جاهزة للتسليم',
      'storeIsOpen': 'المتجر مفتوح',
      'storeIsClosed': 'المتجر مغلق',
      'setupStore': 'إعداد المتجر',
      'contactAndStoreInfo': 'بيانات التواصل والمتجر',
      'loadProfileError': 'تعذر تحميل الملف الشخصي',

      // Products
      'productsList': 'قائمة المنتجات',
      'addNewProduct': 'إضافة منتج جديد',
      'editProduct': 'تعديل المنتج',
      'productName': 'اسم المنتج',
      'productPrice': 'السعر',
      'discountPrice': 'سعر الخصم',
      'stockQuantity': 'الكمية المتاحة',
      'sku': 'رمز SKU',
      'barcode': 'الباركود',
      'weight': 'الوزن (كجم)',
      'productImages': 'صور المنتج',
      'uploadImage': 'رفع صورة',
      'primaryImage': 'رئيسية',
      'setPrimary': 'تعيين كرئيسية',
      'imageUploadedSuccess': 'تم رفع الصورة بنجاح',
      'imageDeletedSuccess': 'تم حذف الصورة بنجاح',
      'primarySetSuccess': 'تم تعيين الصورة الرئيسية',
      'productAddedSuccess': 'تم إضافة المنتج بنجاح',
      'productUpdatedSuccess': 'تم تحديث المنتج بنجاح',

      // Orders
      'orderDetails': 'تفاصيل الطلب',
      'orderNumber': 'رقم الطلب',
      'orderDate': 'تاريخ الطلب',
      'customerInfo': 'معلومات العميل',
      'deliveryAddress': 'عنوان التوصيل',
      'orderItems': 'عناصر الطلب',
      'subtotal': 'المجموع الفرعي',
      'grandTotal': 'المجموع الكلي',
      'acceptOrder': 'قبول الطلب',
      'rejectOrder': 'رفض الطلب',
      'markAsReady': 'تحديد كجاهز للتسليم',
      'rejectionReason': 'سبب الرفض',
      'rejectionReasonHint': 'أدخل سبب رفض الطلب',

      // Statuses
      'statusNew': 'جديد',
      'statusPreparing': 'قيد التجهيز',
      'statusReady': 'جاهز للتسليم',
      'statusCompleted': 'مكتمل',
      'statusCancelled': 'ملغى',
    },
    'en': {
      // App & Navigation
      'appTitle': 'Vendor Dashboard - Diamond Delivery',
      'dashboard': 'Dashboard',
      'orders': 'Orders',
      'products': 'Products',
      'profile': 'Profile',
      'settings': 'Settings',
      'language': 'Language',
      'arabic': 'العربية',
      'english': 'English',
      'changeLanguage': 'Change Language',

      // General Buttons & Actions
      'save': 'Save',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'refresh': 'Refresh',
      'retry': 'Retry',
      'logout': 'Logout',
      'edit': 'Edit',
      'delete': 'Delete',
      'back': 'Back',
      'add': 'Add',
      'submit': 'Submit',
      'saveChanges': 'Save Changes',
      'search': 'Search',

      // Vendor Registration
      'registerTitle': 'Register New Vendor',
      'registerSubtitle': 'Enter store info and location to start selling',
      'createStoreHeader': 'Create Your Store Now',
      'businessInfoSection': 'Business Information',
      'selectCategory': 'Select Business Category',
      'selectCategoryHint': 'Tap to choose store category',
      'storeName': 'Store Name',
      'storeNameHint': 'Enter store name',
      'storeDescription': 'Store Description (Optional)',
      'storeDescriptionHint': 'Enter short description of products & services',
      'bilingualOptions': 'English Information (Optional)',
      'storeNameEn': 'Store Name in English',
      'storeDescriptionEn': 'Store Description in English',
      'contactInfoSection': 'Contact Information',
      'phoneNumber': 'Phone Number',
      'whatsappNumber': 'WhatsApp Number (Optional)',
      'emailAddress': 'Email Address (Optional)',
      'locationSection': 'Store Location',
      'pickLocationOnMap': 'Tap to select store location on map',
      'locationSelected': 'Location selected successfully',
      'displayAddress': 'Display Address',
      'financialsSection': 'Delivery & Orders',
      'deliveryFee': 'Delivery Fee (JOD)',
      'minimumOrder': 'Minimum Order (JOD)',
      'confirmAndRegister': 'Confirm & Create Store',
      'registrationSuccess': 'Store registered successfully',
      'selectLocationFirst': 'Please select store location on the map first',
      'selectCategoryFirst': 'Please select a business category',

      // Form Validation Messages
      'fieldRequired': 'This field is required',
      'invalidPhone': 'Please enter a valid phone number',
      'invalidEmail': 'Please enter a valid email address',
      'invalidNumber': 'Please enter a valid number',

      // Dashboard & Profile
      'storeStats': 'Store Statistics',
      'totalProducts': 'Total Products',
      'newOrders': 'New Orders',
      'preparingOrders': 'In Preparation',
      'readyOrders': 'Ready for Delivery',
      'storeIsOpen': 'Store is Open',
      'storeIsClosed': 'Store is Closed',
      'setupStore': 'Setup Store',
      'contactAndStoreInfo': 'Contact & Store Info',
      'loadProfileError': 'Failed to load profile',

      // Products
      'productsList': 'Products List',
      'addNewProduct': 'Add New Product',
      'editProduct': 'Edit Product',
      'productName': 'Product Name',
      'productPrice': 'Price',
      'discountPrice': 'Discount Price',
      'stockQuantity': 'Available Quantity',
      'sku': 'SKU Code',
      'barcode': 'Barcode',
      'weight': 'Weight (kg)',
      'productImages': 'Product Images',
      'uploadImage': 'Upload Image',
      'primaryImage': 'Primary',
      'setPrimary': 'Set as Primary',
      'imageUploadedSuccess': 'Image uploaded successfully',
      'imageDeletedSuccess': 'Image deleted successfully',
      'primarySetSuccess': 'Primary image updated',
      'productAddedSuccess': 'Product added successfully',
      'productUpdatedSuccess': 'Product updated successfully',

      // Orders
      'orderDetails': 'Order Details',
      'orderNumber': 'Order No.',
      'orderDate': 'Order Date',
      'customerInfo': 'Customer Information',
      'deliveryAddress': 'Delivery Address',
      'orderItems': 'Order Items',
      'subtotal': 'Subtotal',
      'grandTotal': 'Grand Total',
      'acceptOrder': 'Accept Order',
      'rejectOrder': 'Reject Order',
      'markAsReady': 'Mark as Ready',
      'rejectionReason': 'Rejection Reason',
      'rejectionReasonHint': 'Enter reason for rejecting order',

      // Statuses
      'statusNew': 'New',
      'statusPreparing': 'Preparing',
      'statusReady': 'Ready',
      'statusCompleted': 'Completed',
      'statusCancelled': 'Cancelled',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['ar']?[key] ??
        key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
