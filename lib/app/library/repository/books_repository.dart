import 'package:sqflite/sqflite.dart';
import 'package:stodo/core/db/app_database.dart';
import 'package:stodo/core/models/book_model.dart';

class BooksRepository {
  final Future<Database> _db = AppDatabase.instance;

  // MARK: GetRecentBooks
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

  // MARK: GetBooks
  Future<List<BookModel>> getBooks({String? searchQuery, String? status}) async {
    final db = await _db;

    String query = '''
      SELECT
        b.id,
        b.title,
        b.author,
        b.status,
        b.current_page,
        b.total_pages,
        b.updated_at,
        b.image_path,
        b.topic_id,
        t.name as topic_name,
        t.icon_id as icon_id,
        t.color_hex as color_hex
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
      query += ' $defaultComparison AND ';
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      query += '(b.title LIKE ? OR b.author LIKE ?) ';
      args.add('%${searchQuery.trim()}%');
      args.add('%${searchQuery.trim()}%');
    } else {
      query += '$defaultComparison ';
    }
    query += 'GROUP BY b.id';

    final result = await db.rawQuery(query, args);
    return result.map((e) => BookModel.fromMap(e)).toList();
  }

  // MARK: GetBookById
  Future<BookModel?> getBookById(int id) async {
    final db = await _db;

    final result = await db.rawQuery(
      '''
      SELECT
        b.id,
        b.title,
        b.author,
        b.status,
        b.current_page,
        b.total_pages,
        b.updated_at,
        b.image_path,
        b.topic_id,
        t.name as topic_name,
        t.icon_id as icon_id,
        t.color_hex as color_hex
      FROM books b
      LEFT JOIN topics t ON t.id = b.topic_id
      WHERE b.id = ?
      LIMIT 1
      ''',
      [id],
    );

    if (result.isEmpty) return null;

    return BookModel.fromMap(result.first);
  }

  // MARK: CreateBook
  Future<int> createOrUpdateBook(BookModel book) async {
    final db = await _db;

    final map = book.toMap();

    if (book.id == null) {
      // Create
      return await db.insert(
        'books',
        map,
        conflictAlgorithm: ConflictAlgorithm.rollback,
      );
    } else {
      // Update
      return await db.update(
        'books',
        map,
        where: 'id = ?',
        whereArgs: [book.id],
        conflictAlgorithm: ConflictAlgorithm.rollback,
      );
    }
  }

  // MARK: getBooksByTopicId
  Future<List<BookModel>> getBooksByTopicId({
    String? searchQuery,
    String? status,
    int? topicId
  }) async {
    final db = await _db;

    String query = '''
    SELECT
      b.id,
      b.title,
      b.author,
      b.status,
      b.current_page,
      b.total_pages,
      b.updated_at,
      b.image_path,
      b.topic_id,
      t.name as topic_name,
      t.icon_id as icon_id,
      t.color_hex as color_hex
    FROM books b
    LEFT JOIN topics t ON t.id = b.topic_id
    WHERE
  ''';
    String defaultComparison = '(1 = 1)';
    List<dynamic> args = [];

    if (topicId != null && topicId.toString().trim().isNotEmpty) {
      query += ' b.topic_id = ? AND ';
      args.add(topicId);
    }

    if (status != null && status.trim().isNotEmpty) {
      query += ' b.status = ? AND ';
      args.add('%${status.trim()}%');
    } else {
      query += ' $defaultComparison AND ';
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      query += '(b.title LIKE ? OR b.author LIKE ?) ';
      args.add('%${searchQuery.trim()}%');
      args.add('%${searchQuery.trim()}%');
    } else {
      query += '$defaultComparison ';
    }
    query += 'GROUP BY b.id ORDER BY b.title ASC';

    final result = await db.rawQuery(query, args);
    return result.map((e) => BookModel.fromMap(e)).toList();
  }
}