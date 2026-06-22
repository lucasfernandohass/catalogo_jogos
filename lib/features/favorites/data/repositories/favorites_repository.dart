import '../models/favorite_game_model.dart';
import '../sources/favorites_local_source.dart';

class FavoritesRepository {
  final FavoritesLocalSource local;

  FavoritesRepository(this.local);

  Future<void> toggleFavorite(FavoriteGameModel game, bool isFav) {
    if (isFav) {
      return local.removeFavorite(game.id);
    } else {
      return local.addFavorite(game);
    }
  }

  Future<List<FavoriteGameModel>> getFavorites() {
    return local.getFavorites();
  }

  Future<bool> isFavorite(int id) {
    return local.isFavorite(id);
  }
}