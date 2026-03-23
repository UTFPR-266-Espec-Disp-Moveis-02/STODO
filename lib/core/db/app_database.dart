import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _db;

  static Future<Database> get instance async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  static Future<Database> _init() async {
    final path = await getDatabasesPath();

    return openDatabase(
      '$path/app.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE topics (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            icon_id TEXT,
            color_hex TEXT
          );
        ''');

        await db.execute('''
          CREATE TABLE books (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            status TEXT,
            current_page INTEGER,
            total_pages INTEGER,
            topic_id INTEGER,
            updated_at TEXT,
            FOREIGN KEY (topic_id) REFERENCES topics(id)
          );
        ''');
      },
    );
  }
}
