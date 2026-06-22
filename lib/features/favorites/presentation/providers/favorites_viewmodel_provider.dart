import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/favorites_viewmodel.dart';
import 'favorites_repository_provider.dart';
import '../viewmodels/favorites_state.dart';

final favoritesViewModelProvider =
    StateNotifierProvider<FavoritesViewModel, FavoritesState>((ref) {
  final repository = ref.watch(favoritesRepositoryProvider);

  return FavoritesViewModel(repository);
});