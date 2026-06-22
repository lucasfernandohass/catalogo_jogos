import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/game_details_viewmodel.dart';
import '../viewmodels/game_details_state.dart';
import 'game_details_repository_provider.dart';

final gameDetailsViewModelProvider =
    StateNotifierProvider<GameDetailsViewModel, GameDetailsState>((ref) {
  final repository = ref.watch(gameDetailsRepositoryProvider);

  return GameDetailsViewModel(repository);
});