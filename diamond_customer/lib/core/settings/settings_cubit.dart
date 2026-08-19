import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cache/secure_storage_service.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SecureStorageService storageService;

  static const String _keyTheme = 'app_theme_mode';
  static const String _keyLocale = 'app_language_code';

  SettingsCubit(this.storageService) : super(SettingsState.initial()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final themeStr = await storageService.read(_keyTheme);
    final localeStr = await storageService.read(_keyLocale);

    ThemeMode mode = ThemeMode.light;
    if (themeStr == 'dark') {
      mode = ThemeMode.dark;
    } else if (themeStr == 'system') {
      mode = ThemeMode.system;
    }

    Locale loc = const Locale('ar');
    if (localeStr == 'en') {
      loc = const Locale('en');
    }

    emit(state.copyWith(themeMode: mode, locale: loc));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    String value = 'light';
    if (mode == ThemeMode.dark) {
      value = 'dark';
    } else if (mode == ThemeMode.system) {
      value = 'system';
    }

    await storageService.write(_keyTheme, value);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> toggleTheme() async {
    final newMode = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  Future<void> setLocale(Locale locale) async {
    await storageService.write(_keyLocale, locale.languageCode);
    emit(state.copyWith(locale: locale));
  }

  Future<void> toggleLocale() async {
    final newLocale = state.locale.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    await setLocale(newLocale);
  }
}
