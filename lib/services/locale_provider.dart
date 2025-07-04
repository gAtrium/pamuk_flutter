import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  static const List<Locale> supportedLocales = [Locale('en'), Locale('tr')];

  static const Map<String, String> localeNames = {'en': 'English', 'tr': 'Türkçe'};

  LocaleProvider() {
    _loadLocale();
  }

  void setLocale(Locale locale) {
    if (!supportedLocales.contains(locale)) return;

    _locale = locale;
    _saveLocale();
    notifyListeners();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language') ?? 'en';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> _saveLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', _locale.languageCode);
  }
}
