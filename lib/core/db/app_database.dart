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
            title TEXT NOT NULL,
            author TEXT,
            status TEXT,
            current_page INTEGER DEFAULT 0,
            total_pages INTEGER,
            updated_at TEXT,
            image_path TEXT,
            topic_id INTEGER NULL,
            FOREIGN KEY (topic_id) REFERENCES topics(id)
          );
        ''');
      },
    );
  }
}
