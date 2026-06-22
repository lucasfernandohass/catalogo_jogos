import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/features/favorites/data/models/favorite_game_model.dart';
import '/features/favorites/data/repositories/favorites_repository.dart';

class FavoritesViewModel extends StateNotifier<List<FavoriteGameModel>> {
  final FavoritesRepository _repository;

  FavoritesViewModel(this._repository) : super([]) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final data = await _repository.getFavorites();
    state = data;
  }

  Future<void> toggleFavorite(FavoriteGameModel game) async {
    final exists = state.any((g) => g.id == game.id);

    if (exists) {
      await _repository.removeFavorite(game.id);
      state = state.where((g) => g.id != game.id).toList();
    } else {
      await _repository.insertFavorite(game);
      state = [...state, game];
    }
  }

  bool isFavorite(int id) {
    return state.any((g) => g.id == id);
  }
}