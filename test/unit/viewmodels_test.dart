import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:catalogo_jogos/app/theme/theme_viewmodel.dart';
import 'package:catalogo_jogos/core/preferences/preferences_service.dart';
import 'package:catalogo_jogos/features/favorites/data/models/favorite_game_model.dart';
import 'package:catalogo_jogos/features/favorites/data/repositories/favorites_repository.dart';
import 'package:catalogo_jogos/features/favorites/presentation/viewmodels/favorites_viewmodel.dart';

class MockPreferencesService extends Mock implements PreferencesService {}
class MockFavoritesRepository extends Mock implements FavoritesRepository {}
class FavoriteGameModelFake extends Fake implements FavoriteGameModel {}

void main() {
  setUpAll(() {
    registerFallbackValue(FavoriteGameModelFake());
  });

  group('ThemeViewModel', () {
    late MockPreferencesService preferences;

    setUp(() {
      preferences = MockPreferencesService();
    });

    test('toggleTheme flips state and persists the new value', () async {
      when(() => preferences.getDarkMode()).thenReturn(false);
      when(() => preferences.setDarkMode(true))
          .thenAnswer((_) async {});

      final viewModel = ThemeViewModel(preferences);
      await viewModel.toggleTheme();

      expect(viewModel.state.isDarkMode, isTrue);
      verify(() => preferences.setDarkMode(true)).called(1);
    });

    test('loadTheme updates state from preferences', () {
      when(() => preferences.getDarkMode()).thenReturn(true);

      final viewModel = ThemeViewModel(preferences);
      viewModel.loadTheme();

      expect(viewModel.state.isDarkMode, isTrue);
    });
  });

  group('FavoritesViewModel', () {
    late MockFavoritesRepository repository;

    setUp(() {
      repository = MockFavoritesRepository();
    });

    test('toggleFavorite adds game when it is not already favorited', () async {
      final game = FavoriteGameModel(
        id: 10,
        name: 'Star Quest',
        image: 'https://example.com/star.png',
        rating: 4.8,
      );

      when(() => repository.getFavorites())
          .thenAnswer((_) async => <FavoriteGameModel>[]);
      when(() => repository.insertFavorite(any(that: isA<FavoriteGameModel>())))
          .thenAnswer((_) async {});

      final viewModel = FavoritesViewModel(repository);
      await Future<void>.delayed(Duration.zero);
      await viewModel.toggleFavorite(game);

      expect(viewModel.state, contains(game));
      verify(() => repository.insertFavorite(game)).called(1);
    });

    test('toggleFavorite removes game when it is already favorited', () async {
      final game = FavoriteGameModel(
        id: 11,
        name: 'Space Rally',
        image: 'https://example.com/rally.png',
        rating: 4.2,
      );

      when(() => repository.getFavorites())
          .thenAnswer((_) async => [game]);
      when(() => repository.removeFavorite(game.id))
          .thenAnswer((_) async {});

      final viewModel = FavoritesViewModel(repository);
      await Future<void>.delayed(Duration.zero);
      await viewModel.toggleFavorite(game);

      expect(viewModel.state, isEmpty);
      verify(() => repository.removeFavorite(game.id)).called(1);
    });
  });
}
