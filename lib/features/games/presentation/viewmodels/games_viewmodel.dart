import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/games_repository.dart';
import 'games_state.dart';

class GamesViewModel extends StateNotifier<GamesState> {
  final GamesRepository _repository;

  bool _isLoadingMore = false;
  Timer? _debounce;

  GamesViewModel(this._repository) : super(GamesState.initial());

  Future<void> loadGames() async {
    state = state.copyWith(
      isLoading: true,
      games: [],
      page: 1,
      hasReachedEnd: false,
      error: null,
    );

    try {
      final games = await _repository.fetchGames(page: 1);

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
      () async {
        if (query.isEmpty) {
          loadGames();
          return;
        }

        state = state.copyWith(
          isLoading: true,
          games: [],
          page: 1,
          hasReachedEnd: false,
        );

        try {
          final result = await _repository.searchGames(
            query: query,
            page: 1,
          );

          state = state.copyWith(
            isLoading: false,
            games: result,
            page: 1,
          );
        } catch (e) {
          state = state.copyWith(
            isLoading: false,
            error: e.toString(),
          );
        }
      },
    );
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || state.isLoading || state.hasReachedEnd) return;

    _isLoadingMore = true;

    try {
      final nextPage = state.page + 1;

      final newGames = await _repository.fetchGames(
        page: nextPage,
      );

      if (newGames.isEmpty) {
        state = state.copyWith(hasReachedEnd: true);
        return;
      }

      state = state.copyWith(
        games: [...state.games, ...newGames],
        page: nextPage,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}