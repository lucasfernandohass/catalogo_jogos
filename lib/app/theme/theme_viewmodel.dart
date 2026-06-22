import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/preferences/preferences_service.dart';
import 'theme_state.dart';

class ThemeViewModel extends StateNotifier<ThemeState> {
  final PreferencesService preferences;

  ThemeViewModel(this.preferences)
      : super(ThemeState(isDarkMode: preferences.getDarkMode()));

  Future<void> toggleTheme() async {
    final newValue = !state.isDarkMode;

    state = state.copyWith(isDarkMode: newValue);

    await preferences.setDarkMode(newValue);
  }

  void loadTheme() {
    final isDark = preferences.getDarkMode();
    state = ThemeState(isDarkMode: isDark);
  }
}