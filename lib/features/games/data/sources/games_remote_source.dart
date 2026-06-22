import 'package:dio/dio.dart';
import '../../../../app/constants/api_constants.dart';
import '../models/game_model.dart';

class GamesRemoteSource {
  final Dio dio;

  GamesRemoteSource(this.dio);

  Future<List<GameModel>> getGames({
    String? query,
    int page = 1,
  }) async {
    final response = await dio.get(
      ApiConstants.games(
        search: query,
        page: page,
      ),
    );

    final results = response.data['results'] as List;

    return results.map((e) => GameModel.fromMap(e)).toList();
  }
}