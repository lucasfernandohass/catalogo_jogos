import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/sources/game_details_remote_source.dart';
import '../../data/repositories/game_details_repository.dart';
import '../../../../core/network/dio_provider.dart';

final gameDetailsRemoteSourceProvider =
    Provider<GameDetailsRemoteSource>((ref) {
  final dio = ref.watch(dioProvider);
  return GameDetailsRemoteSource(dio);
});

final gameDetailsRepositoryProvider =
    Provider<GameDetailsRepository>((ref) {
  final remote = ref.watch(gameDetailsRemoteSourceProvider);
  return GameDetailsRepository(remote);
});