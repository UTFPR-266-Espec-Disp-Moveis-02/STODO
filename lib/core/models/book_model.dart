import 'package:stodo/core/enums/book_status_enum.dart';
import 'package:stodo/core/models/topic_model.dart';

class BookModel {
  final int? id;
  final String title;
  final String author;
  final String statusStr;
  final BookStatus status;
  final int currentPage;
  final int totalPages;
  final String updatedAt;
  final String? imagePath;
  final TopicModel? topic;
  //final int? topicId;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.statusStr,
    required this.currentPage,
    required this.totalPages,
    required this.updatedAt,
    this.imagePath,
    this.topic,
    //this.topicId,
  }) : status = BookStatus.fromDbString(statusStr);

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      statusStr: map['status'],
      currentPage: map['current_page'],
      totalPages: map['total_pages'],
      updatedAt: map['updated_at'],
      imagePath: map['image_path'],
      //topicId: map['topic_id'],
      topic: map['topic_id'] != null
        ? TopicModel.fromMap({
          'id': map['topic_id'],
          'name': map['topic_name'],
          'icon_id': map['icon_id'],
          'color_hex': map['color_hex'],
        })
        : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'status': statusStr,
      'current_page': currentPage,
      'total_pages': totalPages,
      'updated_at': updatedAt,
      'image_path': imagePath,
      'topic_id': topic?.id,
    };
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is BookModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}