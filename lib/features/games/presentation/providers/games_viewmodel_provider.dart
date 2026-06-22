import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/features/games/presentation/viewmodels/games_viewmodel.dart';
import '/features/games/presentation/viewmodels/games_state.dart';
import 'games_repository.provider.dart';

final gamesViewModelProvider =
    StateNotifierProvider<GamesViewModel, GamesState>(
  (ref) {
    final repository = ref.read(gamesRepositoryProvider);
    return GamesViewModel(repository);
  },
);