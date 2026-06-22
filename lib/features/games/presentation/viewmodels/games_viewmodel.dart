import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/games_repository.dart';
import 'games_state.dart';

class GamesViewModel extends StateNotifier<GamesState> {
  final GamesRepository repository;

  Timer? _debounce;

  GamesViewModel(this.repository) : super(GamesState.initial());

  Future<void> loadGames({String? query}) async {
    state = state.copyWith(isLoading: true, games: [], page: 1);

    try {
      final games = await repository.fetchGames(
        query: query,
        page: 1,
      );

      state = state.copyWith(
        isLoading: false,
        games: games,
        page: 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void searchGames(String query) {
    _debounce?.cancel();

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        loadGames(query: query);
      },
    );
  }

  Future<void> loadMore({String? query}) async {
    if (state.isLoadingMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.page + 1;

      final newGames = await repository.fetchGames(
        query: query,
        page: nextPage,
      );

      state = state.copyWith(
        isLoadingMore: false,
        page: nextPage,
        games: [...state.games, ...newGames],
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}