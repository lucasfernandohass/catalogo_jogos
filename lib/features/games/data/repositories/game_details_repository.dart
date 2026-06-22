import '../models/game_details_model.dart';
import '../sources/game_details_remote_source.dart';

class GameDetailsRepository {
  final GameDetailsRemoteSource remote;

  GameDetailsRepository(this.remote);

  Future<GameDetailsModel> fetchGameDetails(int id) {
    return remote.getGameDetails(id);
  }
}