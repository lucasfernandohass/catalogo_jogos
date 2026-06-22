import '../local/favorites_dao.dart';
import '../models/favorite_game_model.dart';

class FavoritesRepository {
  final FavoritesDao dao;

  FavoritesRepository(this.dao);

  Future<List<FavoriteGameModel>> getFavorites() async {
    return await dao.getFavorites();
  }

  Future<void> insertFavorite(FavoriteGameModel game) {
    return dao.insertFavorite(game);
  }

  Future<void> removeFavorite(int id) {
    return dao.removeFavorite(id);
  }
}