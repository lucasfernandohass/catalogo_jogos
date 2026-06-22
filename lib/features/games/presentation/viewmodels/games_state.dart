import '../../data/models/game_model.dart';

class GamesState {
  final List<GameModel> games;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int page;
  final bool hasReachedEnd;

  const GamesState({
    required this.games,
    required this.isLoading,
    required this.isLoadingMore,
    required this.page,
    required this.hasReachedEnd,
    this.error,
  });

  factory GamesState.initial() {
    return const GamesState(
      games: [],
      isLoading: false,
      isLoadingMore: false,
      page: 1,
      hasReachedEnd: false,
    );
  }

  GamesState copyWith({
    List<GameModel>? games,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? page,
    bool? hasReachedEnd,
  }) {
    return GamesState(
      games: games ?? this.games,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      page: page ?? this.page,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}