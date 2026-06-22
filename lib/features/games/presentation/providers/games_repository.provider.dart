import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/games_repository.dart';
import 'games_remote_source_provider.dart';

final gamesRepositoryProvider = Provider<GamesRepository>((ref) {
  final remote = ref.watch(gamesRemoteSourceProvider);
  return GamesRepository(remote);
});