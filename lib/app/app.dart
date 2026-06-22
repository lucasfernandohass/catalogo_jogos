import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'theme/theme_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeViewModelProvider);

    final baseLight = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: Colors.deepPurple,
    );

    final baseDark = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.deepPurple,
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,

      theme: baseLight.copyWith(
        cardTheme: const CardThemeData(
          elevation: 2,
          margin: EdgeInsets.all(0),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),

      darkTheme: baseDark.copyWith(
        cardTheme: const CardThemeData(
          elevation: 2,
          margin: EdgeInsets.all(0),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),

      themeMode: themeState.isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
    );
  }
}