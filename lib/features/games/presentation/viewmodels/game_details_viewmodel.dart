import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/game_details_repository.dart';
import 'game_details_state.dart';

class GameDetailsViewModel extends StateNotifier<GameDetailsState> {
  final GameDetailsRepository repository;

  GameDetailsViewModel(this.repository)
      : super(GameDetailsState.initial());

  Future<void> loadGame(int id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final game = await repository.fetchGameDetails(id);

      state = state.copyWith(
        isLoading: false,
        game: game,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}