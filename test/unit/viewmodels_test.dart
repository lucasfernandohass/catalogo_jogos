import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:catalogo_jogos/app/theme/theme_viewmodel.dart';
import 'package:catalogo_jogos/core/preferences/preferences_service.dart';

import 'package:catalogo_jogos/features/favorites/data/models/favorite_game_model.dart';
import 'package:catalogo_jogos/features/favorites/data/repositories/favorites_repository.dart';
import 'package:catalogo_jogos/features/favorites/presentation/viewmodels/favorites_viewmodel.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}
class MockPreferencesService extends Mock implements PreferencesService {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      FavoriteGameModel(
        id: 0,
        name: '',
        image: '',
        rating: 0,
      ),
    );
  });

  group('FavoritesViewModel', () {
    late MockFavoritesRepository repo;

    setUp(() {
      repo = MockFavoritesRepository();
    });

    test('deve carregar favoritos ao iniciar', () async {
      final game = FavoriteGameModel(
        id: 1,
        name: 'Portal',
        image: '',
        rating: 4.5,
      );

      when(() => repo.getFavorites())
          .thenAnswer((_) async => [game]);

      final vm = FavoritesViewModel(repo);
      
      await vm.loadFavorites();

      expect(vm.state.length, 1);
      expect(vm.state.first.id, 1);
    });

    test('deve adicionar favorito', () async {
      final game = FavoriteGameModel(
        id: 2,
        name: 'Half Life',
        image: '',
        rating: 4.8,
      );

      when(() => repo.getFavorites())
          .thenAnswer((_) async => []);

      when(() => repo.insertFavorite(any()))
          .thenAnswer((_) async => Future.value());

      final vm = FavoritesViewModel(repo);
      await vm.loadFavorites(); 

      await vm.toggleFavorite(game);

      verify(() => repo.insertFavorite(game)).called(1);

      expect(vm.state, contains(game));
    });

    test('deve remover favorito', () async {
      final game = FavoriteGameModel(
        id: 3,
        name: 'CS',
        image: '',
        rating: 4.2,
      );

      when(() => repo.getFavorites())
          .thenAnswer((_) async => [game]);

      
      when(() => repo.removeFavorite(any()))
          .thenAnswer((_) async => Future.value());

      final vm = FavoritesViewModel(repo);
      await vm.loadFavorites(); 

      await vm.toggleFavorite(game);

      
      verify(() => repo.removeFavorite(game.id)).called(1);
      
      expect(vm.state, isNot(contains(game)));
    });
  });

  group('ThemeViewModel', () {
    late MockPreferencesService prefs;

    setUp(() {
      prefs = MockPreferencesService();
    });

    test('toggle theme', () async {
      when(() => prefs.getDarkMode()).thenReturn(false);
      when(() => prefs.setDarkMode(true)).thenAnswer((_) async {});

      final vm = ThemeViewModel(prefs);

      await vm.toggleTheme();

      expect(vm.state.isDarkMode, true);
    });
  });
}