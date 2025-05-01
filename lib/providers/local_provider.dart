import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../generated/l10n.dart';

class LocaleProvider with ChangeNotifier {
  static const String LANGUAGE_CODE = 'languageCode';

  // Default to English if no saved preference
  Locale _locale = const Locale('en');

  LocaleProvider() {
    // Load saved language preference when initialized
    _loadSavedLanguage();
  }

  Locale get locale => _locale;

  // Load the saved language preference from SharedPreferences
  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? savedLanguage = prefs.getString(LANGUAGE_CODE);

      if (savedLanguage != null) {
        // Check if it's a supported locale before setting
        final Locale newLocale = Locale(savedLanguage);
        if (S.delegate.supportedLocales.contains(newLocale)) {
          _locale = newLocale;
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error loading saved language: $e');
      // If there's an error, we'll just keep the default locale
    }
  }

  // Save and set the new locale
  Future<void> setLocale(Locale locale) async {
    if (!S.delegate.supportedLocales.contains(locale)) return;

    try {
      // Save the selected language code
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(LANGUAGE_CODE, locale.languageCode);

      // Update the locale and notify listeners
      _locale = locale;
      notifyListeners();
    } catch (e) {
      print('Error saving language preference: $e');
      // If we can't save the preference, we'll still update the app's locale
      // for the current session
      _locale = locale;
      notifyListeners();
    }
  }

  // Helper method to check if current language is Arabic
  bool get isArabic => _locale.languageCode == 'ar';
}