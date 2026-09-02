import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final FlutterSecureStorage secureStorage;

  static const _langKey = 'app_language_code';

  LanguageCubit({required this.secureStorage})
    : super(const LanguageState(Locale('ar')));

  Future<void> initLanguage() async {
    final code = await secureStorage.read(key: _langKey);
    if (code != null && (code == 'ar' || code == 'en')) {
      emit(LanguageState(Locale(code)));
    } else {
      emit(const LanguageState(Locale('ar')));
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (languageCode != 'ar' && languageCode != 'en') return;
    await secureStorage.write(key: _langKey, value: languageCode);
    emit(LanguageState(Locale(languageCode)));
  }

  Future<void> toggleLanguage() async {
    final newCode = state.isArabic ? 'en' : 'ar';
    await changeLanguage(newCode);
  }
}
