import 'package:sqflite/sqflite.dart';
import 'package:stodo/core/models/topic_progress_model.dart';

import '../../../core/db/app_database.dart';
import '../../../core/models/book_model.dart';

class DashboardRepository {
  final Future<Database> _db = AppDatabase.instance;

  /// 📚 Livros recentes
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

  /// 🧠 Agregação de tópicos (PERFORMÁTICA)
  Future<List<TopicProgressModel>> getTopicsProgress() async {
    final db = await _db;

    final result = await db.rawQuery('''
      SELECT 
        t.id, t.name, t.icon_id, t.color_hex,
        COALESCE(SUM(b.current_page), 0) as total_read,
        COALESCE(SUM(b.total_pages), 0) as total_pages
      FROM topics t
      LEFT JOIN books b ON t.id = b.topic_id
      GROUP BY t.id
    ''');

    return result.map((e) => TopicProgressModel.fromMap(e)).toList();
  }
}
