import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme_state.dart';
import 'theme_viewmodel.dart';
import '../../core/preferences/preferences_provider.dart';
import '../../core/preferences/preferences_service.dart';

final themeViewModelProvider =
    StateNotifierProvider<ThemeViewModel, ThemeState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);

  return ThemeViewModel(PreferencesService(prefs));
});