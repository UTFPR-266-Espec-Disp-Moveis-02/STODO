import 'package:sqflite/sqflite.dart';
import 'package:stodo/core/db/app_database.dart';
import 'package:stodo/core/models/topic_model.dart';
import 'package:stodo/core/models/topic_progress_model.dart';

class TopicsRepository {
  final Future<Database> _db = AppDatabase.instance;

  // MARK: GetTopicsProgress
  Future<List<TopicProgressModel>> getTopicsProgress({String? searchQuery}) async {
    final db = await _db;

    String query = '''
      SELECT
        t.id, t.name, t.icon_id, t.color_hex,
        COALESCE(SUM(b.current_page), 0) as total_read,
        COALESCE(SUM(b.total_pages), 0) as total_pages
      FROM topics t
      LEFT JOIN books b ON t.id = b.topic_id
    ''';

    List<dynamic> args = [];
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      query += ' WHERE t.name LIKE ?';
      args.add('%${searchQuery.trim()}%');
    }
    query += ' GROUP BY t.id';

    final result = await db.rawQuery(query, args);
    return result.map((e) => TopicProgressModel.fromMap(e)).toList();
  }

  // MARK: CreateTopic
  Future<int> createTopic(TopicModel topic) async {
    final db = await _db;

    return await db.insert(
      'topics',
      {
        'name': topic.name,
        'icon_id': topic.iconId,
        'color_hex': topic.colorHex,
      },
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }

  // MARK: UpdateTopic
  Future<void> updateTopic(TopicModel topic) async {
    final db = await _db;
    await db.update(
      'topics',
      {
        'name': topic.name,
        'icon_id': topic.iconId,
        'color_hex': topic.colorHex,
      },
      where: 'id = ?',
      whereArgs: [topic.id],
    );
  }

  // MARK: DeleteTopic
  Future<void> deleteTopic(int id) async {
    final db = await _db;
    await db.delete('topics', where: 'id = ?', whereArgs: [id]);
  }

  // MARK: GetTopicsDropdown
  Future<List<TopicModel>> getTopicsDropdown() async {
    final db = await _db;

    String query = '''
      SELECT
        t.id,
        t.name,
        t.icon_id,
        t.color_hex
      FROM topics t
    ''';

    List<dynamic> args = [];
    final result = await db.rawQuery(query, args);
    return result.map((e) => TopicModel.fromMap(e)).toList();
  }
}