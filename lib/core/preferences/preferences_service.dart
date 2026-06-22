import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _darkModeKey = "dark_mode";

  final SharedPreferences prefs;

  PreferencesService(this.prefs);

  bool getDarkMode() {
    return prefs.getBool(_darkModeKey) ?? false;
  }

  Future<void> setDarkMode(bool value) async {
    await prefs.setBool(_darkModeKey, value);
  }
}