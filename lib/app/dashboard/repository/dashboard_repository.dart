import 'package:sqflite/sqflite.dart';

import '../../../core/db/app_database.dart';
import '../../../core/models/book_model.dart';

class DashboardRepository {
  final Future<Database> _db = AppDatabase.instance;

  Future<List<BookModel>> getRecentBooks() async {
    final db = await _db;

    final result = await db.rawQuery('''
      SELECT *
      FROM books
      WHERE status = 'Lendo'
      ORDER BY updated_at DESC
      LIMIT 10
    ''');

    return result.map((e) => BookModel.fromMap(e)).toList();
  }
}
