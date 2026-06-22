import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:catalogo_jogos/app/app.dart';
import 'package:catalogo_jogos/core/preferences/preferences_provider.dart';
import 'package:catalogo_jogos/features/favorites/data/models/favorite_game_model.dart';
import 'package:catalogo_jogos/features/favorites/data/repositories/favorites_repository.dart';
import 'package:catalogo_jogos/features/favorites/presentation/providers/favorites_repository_provider.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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

  group('App Flow', () {
    late MockSharedPreferences mockPrefs;
    late MockFavoritesRepository mockFavoritesRepo;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      mockFavoritesRepo = MockFavoritesRepository();

      when(() => mockPrefs.getBool(any())).thenReturn(false);
      when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);

      when(() => mockFavoritesRepo.getFavorites()).thenAnswer((_) async => []);
      when(() => mockFavoritesRepo.insertFavorite(any())).thenAnswer((_) async => {});
      when(() => mockFavoritesRepo.removeFavorite(any())).thenAnswer((_) async => {});
    });

    Future<void> pumpApp(WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            favoritesRepositoryProvider.overrideWithValue(mockFavoritesRepo),
          ],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 5));
    }

    Future<void> waitForWidget(
      WidgetTester tester,
      Finder finder, {
      int maxAttempts = 20,
      Duration pause = const Duration(milliseconds: 300),
    }) async {
      for (int i = 0; i < maxAttempts; i++) {
        await tester.pump(pause);
        if (finder.evaluate().isNotEmpty) {
          return;
        }
      }
      throw Exception('Widget not found: $finder after $maxAttempts attempts');
    }

    testWidgets(
      'deve abrir a aplicação e exibir a HomePage',
      (tester) async {
        await pumpApp(tester);

        expect(find.text('Catálogo de Jogos'), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
        expect(find.byIcon(Icons.favorite), findsWidgets);
      },
    );

    testWidgets(
      'deve navegar para a página de favoritos',
      (tester) async {
        await pumpApp(tester);

        final favoriteIcon = find.byIcon(Icons.favorite);
        await waitForWidget(tester, favoriteIcon);
        expect(favoriteIcon, findsAtLeastNWidgets(1));

        await tester.tap(favoriteIcon.first);
        await tester.pumpAndSettle();

        expect(find.text('Favoritos'), findsOneWidget);
      },
    );

  });
}