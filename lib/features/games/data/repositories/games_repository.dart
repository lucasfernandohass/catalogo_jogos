import '../models/game_model.dart';
import '../sources/games_remote_source.dart';

class GamesRepository {
  final GamesRemoteSource remote;

  GamesRepository(this.remote);

  Future<List<GameModel>> fetchGames({
    String? query,
    int page = 1,
  }) {
    return remote.getGames(query: query, page: page);
  }
}