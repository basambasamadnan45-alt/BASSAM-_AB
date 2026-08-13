import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsService extends ChangeNotifier {
  static const String _languageKey = 'app_language';
  static const String _themeKey = 'app_theme';

  Locale _locale = const Locale('ar');
  ThemeMode _themeMode = ThemeMode.light;

  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;

  bool get isArabic => _locale.languageCode == 'ar';
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final language = prefs.getString(_languageKey) ?? 'ar';
    final theme = prefs.getString(_themeKey) ?? 'light';

    _locale = Locale(
      language == 'en' ? 'en' : 'ar',
    );

    _themeMode = switch (theme) {
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.light,
    };

    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    final language = languageCode == 'en' ? 'en' : 'ar';

    _locale = Locale(language);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;

    final prefs = await SharedPreferences.getInstance();

    final value = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
      ThemeMode.light => 'light',
    };

    await prefs.setString(_themeKey, value);

    notifyListeners();
  }
}
