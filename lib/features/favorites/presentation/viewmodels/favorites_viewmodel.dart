import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/favorite_game_model.dart';
import '../../data/repositories/favorites_repository.dart';

class FavoritesViewModel extends StateNotifier<List<FavoriteGameModel>> {
  final FavoritesRepository repository;

  FavoritesViewModel(this.repository) : super([]) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    state = await repository.getFavorites();
  }

  Future<void> toggleFavorite(FavoriteGameModel game) async {
    final exists = state.any((g) => g.id == game.id);

    if (exists) {
      await repository.removeFavorite(game.id);
      state = state.where((g) => g.id != game.id).toList();
    } else {
      await repository.insertFavorite(game);
      state = [...state, game];
    }
  }

  bool isFavorite(int id) {
    return state.any((g) => g.id == id);
  }
}