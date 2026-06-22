import '../../data/models/favorite_game_model.dart';

class FavoritesState {
  final List<FavoriteGameModel> favorites;
  final bool isLoading;
  final String? error;

  const FavoritesState({
    required this.favorites,
    required this.isLoading,
    this.error,
  });

  factory FavoritesState.initial() {
    return const FavoritesState(
      favorites: [],
      isLoading: false,
      error: null,
    );
  }

  FavoritesState copyWith({
    List<FavoriteGameModel>? favorites,
    bool? isLoading,
    String? error,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}