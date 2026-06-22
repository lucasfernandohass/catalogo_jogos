import 'package:flutter_test/flutter_test.dart';
import 'package:catalogo_jogos/features/favorites/data/models/favorite_game_model.dart';
import 'package:catalogo_jogos/features/games/data/models/game_model.dart';

void main() {
  group('GameModel', () {
    test('fromJson parses numeric rating and image', () {
      final json = {
        'id': 1,
        'name': 'Aventura',
        'background_image': 'https://example.com/cover.png',
        'rating': 4,
      };

      final game = GameModel.fromJson(json);

      expect(game.id, 1);
      expect(game.name, 'Aventura');
      expect(game.image, 'https://example.com/cover.png');
      expect(game.rating, 4.0);
    });

    test('fromJson defaults missing image and rating values', () {
      final json = {
        'id': 2,
        'name': 'Puzzle',
      };

      final game = GameModel.fromJson(json);

      expect(game.image, '');
      expect(game.rating, 0.0);
    });
  });

  group('FavoriteGameModel', () {
    test('toMap and fromMap preserve all fields', () {
      final original = FavoriteGameModel(
        id: 99,
        name: 'Retro Racer',
        image: 'https://example.com/retro.png',
        rating: 4.5,
      );

      final map = original.toMap();
      final restored = FavoriteGameModel.fromMap(map);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.image, original.image);
      expect(restored.rating, original.rating);
    });
  });
}
