import 'package:stodo/core/enums/book_status_enum.dart';

sealed class BookProgressState {}

class BookProgressIdle extends BookProgressState {
  final BookStatus status;
  final int currentPage;

  BookProgressIdle({required this.status, required this.currentPage});
}

class BookProgressSaving extends BookProgressState {}

class BookProgressSaved extends BookProgressState {
  final BookStatus status;
  final int currentPage;

  BookProgressSaved({required this.status, required this.currentPage});
}

class BookProgressError extends BookProgressState {
  final String message;

  BookProgressError(this.message);
}
