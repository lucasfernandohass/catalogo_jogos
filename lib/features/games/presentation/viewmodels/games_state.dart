import '../../data/models/game_model.dart';

class GamesState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<GameModel> games;
  final String? error;
  final int page;

  const GamesState({
    required this.isLoading,
    required this.isLoadingMore,
    required this.games,
    required this.page,
    this.error,
  });

  factory GamesState.initial() {
    return const GamesState(
      isLoading: false,
      isLoadingMore: false,
      games: [],
      page: 1,
      error: null,
    );
  }

  GamesState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<GameModel>? games,
    String? error,
    int? page,
  }) {
    return GamesState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      games: games ?? this.games,
      page: page ?? this.page,
      error: error,
    );
  }
}