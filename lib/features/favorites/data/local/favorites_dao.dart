import 'package:sqflite/sqflite.dart';
import '/core/database/sqlite_service.dart';
import '../models/favorite_game_model.dart';

class FavoritesDao {
  final SqliteService dbService;

  FavoritesDao(this.dbService);

  Future<Database> get _db async => await dbService.database;

 Future<List<FavoriteGameModel>> getFavorites() async {
    final db = await _db;
    final result = await db.query('favorites');

    return result.map((e) => FavoriteGameModel.fromMap(e)).toList();
  }

  Future<void> insertFavorite(FavoriteGameModel game) async {
    final db = await _db;
    await db.insert(
      'favorites',
      game.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(int id) async {
    final db = await _db;
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}