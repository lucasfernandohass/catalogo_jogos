import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteService {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'games.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY,
            name TEXT,
            image TEXT
          )
        ''');
      },
    );
  }

  // =========================
  // FAVORITOS
  // =========================

  Future<void> insertFavorite(Map<String, dynamic> game) async {
    final db = await database;
    await db.insert(
      'favorites',
      game,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteFavorite(int id) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    return db.query('favorites');
  }

  Future<bool> isFavorite(int id) async {
    final db = await database;

    final result = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );

    return result.isNotEmpty;
  }
}