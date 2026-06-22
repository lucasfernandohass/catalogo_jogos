import '/features/games/data/sources/games_remote_source.dart';
import '/features/games/data/models/game_model.dart';

class GamesRepository {
  final GamesRemoteSource remote;

  GamesRepository(this.remote);

  Future<List<GameModel>> fetchGames({required int page}) {
    return remote.fetchGames(page: page);
  }

  Future<List<GameModel>> searchGames({
    required String query,
    required int page,
  }) {
    return remote.searchGames(query: query, page: page);
  }

  Future<GameModel> fetchGameDetails(int id) {
    return remote.fetchGameDetails(id);
  }
}