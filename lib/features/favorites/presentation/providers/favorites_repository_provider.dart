import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/favorites_repository.dart';
import '../../data/local/favorites_dao.dart';
import '/core/database/sqlite_service.dart';

final sqliteProvider = Provider<SqliteService>((ref) {
  return SqliteService();
});

final favoritesDaoProvider = Provider<FavoritesDao>((ref) {
  return FavoritesDao(ref.read(sqliteProvider));
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository(ref.read(favoritesDaoProvider));
});

//import 'package:catalogo_jogos/features/favorites/presentation/providers/favorites_repository_provider.dart';