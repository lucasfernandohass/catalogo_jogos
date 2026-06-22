import '../../data/models/game_details_model.dart';

class GameDetailsState {
  final bool isLoading;
  final GameDetailsModel? game;
  final String? error;

  const GameDetailsState({
    required this.isLoading,
    required this.game,
    required this.error,
  });

  factory GameDetailsState.initial() {
    return const GameDetailsState(
      isLoading: false,
      game: null,
      error: null,
    );
  }

  GameDetailsState copyWith({
    bool? isLoading,
    GameDetailsModel? game,
    String? error,
  }) {
    return GameDetailsState(
      isLoading: isLoading ?? this.isLoading,
      game: game ?? this.game,
      error: error,
    );
  }
}