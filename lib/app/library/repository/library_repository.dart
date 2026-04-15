import 'package:sqflite/sqflite.dart';

import '../../../core/db/app_database.dart';
import '../../../core/models/book_model.dart';

class LibraryRepository {
  final Future<Database> _db = AppDatabase.instance;

  Future<List<BookModel>> getBooksByStatus({
    String? query,
    String? status,
  }) async {
    final db = await _db;

    final where = <String>[];
    final args = <dynamic>[];

    if (query != null && query.isNotEmpty) {
      where.add('title LIKE ?');
      args.add('%$query%');
    }

    if (status != null && status.isNotEmpty) {
      where.add('status = ?');
      args.add(status);
    }

    final whereClause = where.isNotEmpty ? 'WHERE ${where.join(' AND ')}' : '';
    final result = await db.rawQuery('''
      SELECT 
        b.*, 
        t.id AS topic_id,
        t.name AS topic_name,
        t.icon_id,
        t.color_hex
      FROM books b
      LEFT JOIN topics t ON t.id = b.topic_id
      $whereClause
      ORDER BY b.updated_at DESC
    ''', args);

    return result.map((e) => BookModel.fromMap(e)).toList();
  }
}
