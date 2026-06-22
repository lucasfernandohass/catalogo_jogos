import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/favorite_game_model.dart';
import '../../data/repositories/favorites_repository.dart';
import 'favorites_state.dart';

class FavoritesViewModel extends StateNotifier<FavoritesState> {
  final FavoritesRepository repository;

  FavoritesViewModel(this.repository)
      : super(FavoritesState.initial()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final list = await repository.getFavorites();

    state = state.copyWith(
      favorites: list,
    );
  }

  Future<void> toggleFavorite(FavoriteGameModel game) async {
    final isFav = state.favorites.any((g) => g.id == game.id);

    await repository.toggleFavorite(game, isFav);

    await loadFavorites();
  }
}