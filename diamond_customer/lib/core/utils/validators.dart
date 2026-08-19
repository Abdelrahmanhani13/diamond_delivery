class EmailValidator {
  // كان الـ regex القديم `{2,4}` في آخره بيرفض أي TLD أطول من 4
  // حروف زي .info أو .online أو .technology. استبدلناه بـ
  // `[a-zA-Z]{2,}` عشان يقبل أي طول منطقي للـ TLD.
  static final RegExp _emailRegex = RegExp(
    r'^[\w.+-]+@[\w-]+(\.[\w-]+)*\.[a-zA-Z]{2,}$',
  );

  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'عنوان البريد الإلكتروني مطلوب';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'الرجاء إدخال عنوان بريد إلكتروني صحيح';
    }
    return null;
  }
}

class NameValidator {
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال الاسم الكامل';
    }
    if (value.trim().length < 3) {
      return 'الاسم يجب أن يكون 3 حروف على الأقل';
    }
    return null;
  }
}

class PasswordValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (value.length < 8) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }
    return null;
  }
}

class ConfirmPasswordValidator {
  static String? validate(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'يرجى تأكيد كلمة المرور';
    }
    if (value != originalPassword) {
      return 'كلمتا المرور غير متطابقتين';
    }
    return null;
  }
}

class PhoneValidator {
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    if (value.trim().length < 10) {
      return 'يرجى إدخال رقم هاتف صحيح';
    }
    return null;
  }
}

class OTPValidator {
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رمز التحقق مطلوب';
    }
    if (value.trim().length != 6) {
      return 'رمز التحقق يجب أن يكون 6 أرقام';
    }
    return null;
  }
}
