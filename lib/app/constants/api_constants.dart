import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static const String _baseUrl = "https://api.rawg.io/api";

  /// API KEY vinda do .env
  static String get apiKey {
    final key = dotenv.env['RAWG_API_KEY'];

    if (key == null || key.isEmpty) {
      throw Exception("RAWG_API_KEY não encontrada no .env");
    }

    return key;
  }

  /// URL base (RAWG)
  static String get baseUrl => _baseUrl;

  /// LISTA DE JOGOS (com ou sem busca)
  static String games({
    String? search,
    int page = 1,
  }) {
    final query = (search != null && search.isNotEmpty)
        ? "&search=$search"
        : "";

    return "$_baseUrl/games?key=$apiKey&page=$page$query";
  }
   static String gameDetails(int id) {
    return "$_baseUrl/games/$id?key=$apiKey";
  }
}