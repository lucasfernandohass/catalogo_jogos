import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sqlite_provider.dart';
import '../../data/repositories/favorites_repository.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  final local = ref.watch(sqliteProvider);
  return FavoritesRepository(local);
});