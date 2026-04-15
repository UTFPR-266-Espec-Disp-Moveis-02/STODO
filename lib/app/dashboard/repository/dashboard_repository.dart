import 'package:sqflite/sqflite.dart';
import 'package:stodo/core/enums/book_status_enum.dart';

import '../../../core/db/app_database.dart';
import '../../../core/models/book_model.dart';

class DashboardRepository {
  final Future<Database> _db = AppDatabase.instance;

  Future<List<BookModel>> getRecentBooks() async {
    final db = await _db;

    final statusLendo = BookStatus.reading.name;
    final result = await db.rawQuery('''
      SELECT 
        b.*,
        t.id AS topic_id,
        t.name AS topic_name,
        t.icon_id,
        t.color_hex
      FROM books b
      LEFT JOIN topics t ON t.id = b.topic_id
      WHERE b.status = ?
      ORDER BY b.updated_at DESC
      LIMIT 10
    ''', [statusLendo]);

    return result.map((e) => BookModel.fromMap(e)).toList();
  }
}
