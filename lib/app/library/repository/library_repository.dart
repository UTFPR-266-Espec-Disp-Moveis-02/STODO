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

    final result = await db.query(
      'books',
      where: where.isNotEmpty ? where.join(' AND ') : null,
      whereArgs: args,
      orderBy: 'updated_at DESC',
    );

    return result.map((e) => BookModel.fromMap(e)).toList();
  }
}
