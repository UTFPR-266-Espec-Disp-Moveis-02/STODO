import 'package:stodo/core/enums/book_status_enum.dart';

class BookModel {
  final int id;
  final String title;
  final String author;
  final String statusStr;
  final BookStatus status;
  final int currentPage;
  final int totalPages;
  final int topicId;
  final String updatedAt;
  final String? imagePath;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.statusStr,
    required this.currentPage,
    required this.totalPages,
    required this.topicId,
    required this.updatedAt,
    this.imagePath,
  }) : status = BookStatus.fromDbString(statusStr);

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      statusStr: map['status'],
      currentPage: map['current_page'],
      totalPages: map['total_pages'],
      topicId: map['topic_id'],
      updatedAt: map['updated_at'],
      imagePath: map['image_path'],
    );
  }
}