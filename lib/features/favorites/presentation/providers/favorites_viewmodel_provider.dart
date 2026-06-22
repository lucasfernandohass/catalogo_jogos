import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/database/sqlite_service.dart';
import '../../data/local/favorites_dao.dart';
import '../../data/repositories/favorites_repository.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../../data/models/favorite_game_model.dart';

final sqliteProvider = Provider((ref) => SqliteService());

final favoritesDaoProvider = Provider(
  (ref) => FavoritesDao(ref.read(sqliteProvider)),
);

final favoritesRepositoryProvider = Provider(
  (ref) => FavoritesRepository(ref.read(favoritesDaoProvider)),
);

final favoritesViewModelProvider =
    StateNotifierProvider<FavoritesViewModel, List<FavoriteGameModel>>(
  (ref) => FavoritesViewModel(ref.read(favoritesRepositoryProvider)),
);