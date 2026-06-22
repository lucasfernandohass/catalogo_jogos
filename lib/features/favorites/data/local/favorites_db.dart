import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FavoritesDb {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'favorites.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY,
            name TEXT,
            image TEXT
          )
        ''');
      },
    );
  }
}