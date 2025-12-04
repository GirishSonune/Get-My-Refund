import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _localeKey = 'app_locale';
  static final PreferencesService _instance = PreferencesService._internal();

  factory PreferencesService() => _instance;

  PreferencesService._internal();

  Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  Future<Locale?> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey);
    return languageCode != null ? Locale(languageCode) : null;
  }
}
