import 'package:stodo/core/enums/book_status_enum.dart';
import 'package:stodo/core/models/book_model.dart';
import 'package:stodo/core/models/topic_model.dart';

class BooksState {
  final LoadStatus status;

  final List<BookStatus> statusOptions;
  final List<TopicModel> topicOptions;

  final BookStatus? selectedStatus;
  final TopicModel? selectedTopic;
  final String? imagePath;

  final BookModel? book;
  final List<BookModel> booksList;

  BooksState({
    required this.status,
    this.booksList = const [],
    this.book,
    this.statusOptions = const [],
    this.topicOptions = const [],
    this.selectedStatus,
    this.selectedTopic,
    this.imagePath,
  });

  BooksState copyWith({
    LoadStatus? status,
    BookModel? book,
    List<BookModel>? booksList,
    List<BookStatus>? statusOptions,
    List<TopicModel>? topicOptions,
    BookStatus? selectedStatus,
    TopicModel? selectedTopic,
    String? imagePath,
  }) {
    return BooksState(
      status: status ?? this.status,
      book: book ?? this.book,
      booksList: booksList ?? this.booksList,
      statusOptions: statusOptions ?? this.statusOptions,
      topicOptions: topicOptions ?? this.topicOptions,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedTopic: selectedTopic ?? this.selectedTopic,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

sealed class LoadStatus {}
class Initial extends LoadStatus {}
class Loading extends LoadStatus {}
class LoadSuccess extends LoadStatus {}
class SubmitSuccess extends LoadStatus {}
class Error extends LoadStatus {
  final String message;
  Error({required this.message});
}