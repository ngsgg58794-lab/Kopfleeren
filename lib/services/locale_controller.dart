import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Hält die in der App gewählte Sprache. `null` = Systemsprache.
class LocaleController extends ChangeNotifier {
  static const _key = 'app_locale';
  static const supported = [Locale('en'), Locale('de')];

  Locale? _locale;
  Locale? get locale => _locale;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    _locale = supported.where((l) => l.languageCode == code).firstOrNull;
  }

  Future<void> set(Locale? locale) async {
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_key);
    } else {
      await prefs.setString(_key, locale.languageCode);
    }
  }
}
