import 'package:sqflite/sqflite.dart';
import '/core/database/app_database.dart';
import '../models/favorite_game_model.dart';

class FavoritesLocalSource {
  Future<Database> get db async => await AppDatabase.database;

  Future<void> addFavorite(FavoriteGameModel game) async {
    final database = await db;

    await database.insert(
      'favorites',
      game.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(int id) async {
    final database = await db;

    await database.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<FavoriteGameModel>> getFavorites() async {
    final database = await db;

    final result = await database.query('favorites');

    return result.map((e) => FavoriteGameModel.fromMap(e)).toList();
  }

  Future<bool> isFavorite(int id) async {
    final database = await db;

    final result = await database.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );

    return result.isNotEmpty;
  }
}