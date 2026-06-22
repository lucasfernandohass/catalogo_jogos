import 'package:dio/dio.dart';

import '/app/constants/api_constants.dart';
import '../models/game_model.dart';

class GamesRemoteSource {
  final Dio dio;

  GamesRemoteSource(this.dio);

  Future<List<GameModel>> fetchGames({
    required int page,
  }) async {
    try {
      final response = await dio.get(
        '/games',
        queryParameters: {
          'key': ApiConstants.apiKey,
          'page': page,
        },
      );

      final List results = response.data['results'];

      return results
          .map((json) => GameModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      final status = e.response?.statusCode;

      if (status == 502) {
        throw Exception(
          'Serviço RAWG instável (502). Tente novamente.',
        );
      }

      if (status == 429) {
        throw Exception(
          'Muitas requisições. Aguarde alguns segundos.',
        );
      }

      throw Exception(
        e.message ?? 'Erro ao buscar jogos',
      );
    }
  }

  Future<List<GameModel>> searchGames({
    required String query,
    required int page,
  }) async {
    try {
      final response = await dio.get(
        '/games',
        queryParameters: {
          'key': ApiConstants.apiKey,
          'search': query,
          'page': page,
        },
      );

      final List results = response.data['results'];

      return results
          .map((json) => GameModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      final status = e.response?.statusCode;

      if (status == 502) {
        throw Exception('API instável no momento (502)');
      }

      if (status == 429) {
        throw Exception('Limite de requisições atingido');
      }

      throw Exception(e.message ?? 'Erro ao buscar jogos');
    }
  }

  Future<GameModel> fetchGameDetails(int id) async {
    try {
      final response = await dio.get(
        '/games/$id',
        queryParameters: {
          'key': ApiConstants.apiKey,
        },
      );

      return GameModel.fromJson(response.data);
    } on DioException catch (e) {
      final status = e.response?.statusCode;

      if (status == 502) {
        throw Exception('API RAWG instável (502)');
      }

      throw Exception(e.message ?? 'Erro ao buscar detalhes');
    }
  }
}