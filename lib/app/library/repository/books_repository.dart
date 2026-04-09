import 'package:sqflite/sqflite.dart';
import 'package:stodo/core/db/app_database.dart';
import 'package:stodo/core/models/book_model.dart';

class BooksRepository {
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

  Future<List<BookModel>> getBooks({String? searchQuery, String? status}) async {
    final db = await _db;

    String query = '''
      SELECT *
      FROM books b
      LEFT JOIN topics t ON t.id = b.topic_id
      WHERE 
    ''';
    String defaultComparison = '(1 = 1)';
    List<dynamic> args = [];

    if (status != null && status.trim().isNotEmpty) {
      query += ' b.status = ? AND ';
      args.add('%${status.trim()}%');
    } else {
      query += '$defaultComparison AND';
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      query += '(b.title LIKE ? OR b.author LIKE ?) ';
      args.add('%${searchQuery.trim()}%');
      args.add('%${searchQuery.trim()}%');
    } else {
      query += ' $defaultComparison';
    }
    query += ' GROUP BY t.id';

    final result = await db.rawQuery(query, args);
    return result.map((e) => BookModel.fromMap(e)).toList();
  }

  Future<int> createBook(BookModel book) async {
    final db = await _db;

    // TODO: Insert
    return await db.insert(
      'books',
      {},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}