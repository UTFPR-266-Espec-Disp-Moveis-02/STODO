class BookModel {
  final int id;
  final String title;
  final String status;
  final int currentPage;
  final int totalPages;
  final int topicId;
  final String updatedAt;

  BookModel({
    required this.id,
    required this.title,
    required this.status,
    required this.currentPage,
    required this.totalPages,
    required this.topicId,
    required this.updatedAt,
  });

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'],
      title: map['title'],
      status: map['status'],
      currentPage: map['current_page'],
      totalPages: map['total_pages'],
      topicId: map['topic_id'],
      updatedAt: map['updated_at'],
    );
  }
}
