import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:catalogo_jogos/app/app.dart';
import 'package:catalogo_jogos/app/theme/theme_viewmodel.dart';
import 'package:catalogo_jogos/app/theme/theme_state.dart';
import 'package:catalogo_jogos/core/preferences/preferences_service.dart';
import 'package:catalogo_jogos/features/favorites/data/local/favorites_dao.dart';
import 'package:catalogo_jogos/features/favorites/data/models/favorite_game_model.dart';
import 'package:catalogo_jogos/features/favorites/data/repositories/favorites_repository.dart';
import 'package:catalogo_jogos/features/favorites/presentation/pages/favorites_page.dart';
import 'package:catalogo_jogos/features/favorites/presentation/viewmodels/favorites_viewmodel.dart';
import 'package:catalogo_jogos/features/favorites/presentation/providers/favorites_viewmodel_provider.dart';
import 'package:catalogo_jogos/features/games/data/models/game_model.dart';
import 'package:catalogo_jogos/features/games/data/repositories/games_repository.dart';
import 'package:catalogo_jogos/features/games/data/sources/games_remote_source.dart';
import 'package:catalogo_jogos/features/games/presentation/pages/home_page.dart';
import 'package:catalogo_jogos/features/games/presentation/viewmodels/games_state.dart';
import 'package:catalogo_jogos/features/games/presentation/viewmodels/games_viewmodel.dart';
import 'package:catalogo_jogos/features/games/presentation/providers/games_viewmodel_provider.dart';
import 'package:catalogo_jogos/app/theme/theme_provider.dart';

class FakePreferencesService implements PreferencesService {
  bool _darkMode = false;

  @override
  SharedPreferences get prefs => throw UnimplementedError();

  @override
  bool getDarkMode() => _darkMode;

  @override
  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
  }
}

class FakeGamesRepository implements GamesRepository {
  @override
  GamesRemoteSource get remote => throw UnimplementedError();

  @override
  Future<GameModel> fetchGameDetails(int id) async {
    return GameModel(id: id, name: 'Detalhes do Jogo', image: '', rating: 3.5);
  }

  @override
  Future<List<GameModel>> fetchGames({required int page}) async {
    return [
      GameModel(id: 1, name: 'Wings of Fire', image: '', rating: 4.7),
    ];
  }

  @override
  Future<List<GameModel>> searchGames({required String query, required int page}) async {
    return [
      GameModel(id: 2, name: 'Search Hero', image: '', rating: 4.0),
    ];
  }
}

class FakeFavoritesRepository implements FavoritesRepository {
  @override
  FavoritesDao get dao => throw UnimplementedError();

  @override
  Future<void> insertFavorite(FavoriteGameModel game) async {}

  @override
  Future<List<FavoriteGameModel>> getFavorites() async => [];

  @override
  Future<void> removeFavorite(int id) async {}
}

void main() {
  testWidgets('HomePage renders title and game card', (tester) async {
    final gamesRepository = FakeGamesRepository();
    final favoritesRepository = FakeFavoritesRepository();
    final themeService = FakePreferencesService();

    final gamesViewModelOverride = StateNotifierProvider<GamesViewModel, GamesState>(
      (ref) => GamesViewModel(gamesRepository),
    );
    final favoritesViewModelOverride = StateNotifierProvider<FavoritesViewModel, List<FavoriteGameModel>>(
      (ref) => FavoritesViewModel(favoritesRepository),
    );
    final themeViewModelOverride = StateNotifierProvider<ThemeViewModel, ThemeState>(
      (ref) => ThemeViewModel(themeService),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gamesViewModelProvider.overrideWithProvider(gamesViewModelOverride),
          favoritesViewModelProvider.overrideWithProvider(favoritesViewModelOverride),
          themeViewModelProvider.overrideWithProvider(themeViewModelOverride),
        ],
        child: const MaterialApp(home: HomePage()),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Catálogo de Jogos'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Wings of Fire'), findsOneWidget);
  });

  testWidgets('FavoritesPage renders empty state when there are no favorites',
      (tester) async {
    final favoritesRepository = FakeFavoritesRepository();
    final themeService = FakePreferencesService();

    final favoritesViewModelOverride = StateNotifierProvider<FavoritesViewModel, List<FavoriteGameModel>>(
      (ref) => FavoritesViewModel(favoritesRepository),
    );
    final themeViewModelOverride = StateNotifierProvider<ThemeViewModel, ThemeState>(
      (ref) => ThemeViewModel(themeService),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          favoritesViewModelProvider.overrideWithProvider(favoritesViewModelOverride),
          themeViewModelProvider.overrideWithProvider(themeViewModelOverride),
        ],
        child: const MaterialApp(home: FavoritesPage()),
      ),
    );

    await tester.pump();

    expect(find.text('Nenhum favorito ainda'), findsOneWidget);
  });

  testWidgets('App renders home route and top action buttons', (tester) async {
    final gamesRepository = FakeGamesRepository();
    final favoritesRepository = FakeFavoritesRepository();
    final themeService = FakePreferencesService();

    final gamesViewModelOverride = StateNotifierProvider<GamesViewModel, GamesState>(
      (ref) => GamesViewModel(gamesRepository),
    );
    final favoritesViewModelOverride = StateNotifierProvider<FavoritesViewModel, List<FavoriteGameModel>>(
      (ref) => FavoritesViewModel(favoritesRepository),
    );
    final themeViewModelOverride = StateNotifierProvider<ThemeViewModel, ThemeState>(
      (ref) => ThemeViewModel(themeService),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gamesViewModelProvider.overrideWithProvider(gamesViewModelOverride),
          favoritesViewModelProvider.overrideWithProvider(favoritesViewModelOverride),
          themeViewModelProvider.overrideWithProvider(themeViewModelOverride),
        ],
        child: const App(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Catálogo de Jogos'), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}
