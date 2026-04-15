import 'package:sqflite/sqflite.dart';
import 'package:stodo/core/enums/book_status_enum.dart';

import '../../../core/db/app_database.dart';
import '../../../core/models/book_model.dart';

class LibraryRepository {
  final Future<Database> _db = AppDatabase.instance;

  Future<void> updateBookProgress(
    int id,
    BookStatus status,
    int currentPage,
  ) async {
    final db = await _db;
    await db.update(
      'books',
      {
        'status': status.toDbString(),
        'current_page': currentPage,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteBook(int id) async {
    final db = await _db;
    await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }

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
