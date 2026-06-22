import 'package:dio/dio.dart';
import '../../../../app/constants/api_constants.dart';
import '../models/game_details_model.dart';

class GameDetailsRemoteSource {
  final Dio dio;

  GameDetailsRemoteSource(this.dio);

  Future<GameDetailsModel> getGameDetails(int id) async {
    final response = await dio.get(
      ApiConstants.gameDetails(id),
    );

    return GameDetailsModel.fromMap(response.data);
  }
}