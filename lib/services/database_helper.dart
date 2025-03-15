import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  // Singleton instance
  DbHelper._();
  static final DbHelper instance = DbHelper._();

  Database? _database;

  final String _songTable = 'songTable';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    var databasePath = await getDatabasesPath();
    final path = join(databasePath, "converter.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE $_songTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          song TEXT,
          image TEXT,
          label TEXT,
          favorite INTEGER
        )
      ''');
    });
  }
  Future<bool> isSongFavorite(String songName) async {
    final db = await database;
    var res = await db.query('$_songTable', where: 'name = ?', whereArgs: [songName]);
    return res.isNotEmpty;
  }

  Future<void> insertData({
    required String name,
    required String song,
    required String image,
    required String label,
    required int fav
  }) async {
    final db = await database;
    await db.insert(
      _songTable,
      {'name': name, 'song': song, 'image': image, 'label': label,'favorite':fav},
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<int> deleteSong(String songName) async {
    final db = await database;
    return await db.delete(
      '$_songTable', // Table name
      where: 'name = ?', // Condition
      whereArgs: [songName], // Argument for condition
    );
  }
  Future<int> delete(int index) async {
    final db = await database;
    return await db.delete(
      '$_songTable', // Table name
      where: 'id = ?', // Condition
      whereArgs: [index], // Argument for condition
    );
  }

  Future<List<Map<String, dynamic>>> fetchDataFromDatabase() async {
    final db = await database;
    final List<Map<String, dynamic>> data = await db.query(_songTable);
    // Debug print
    return data;
  }

}
