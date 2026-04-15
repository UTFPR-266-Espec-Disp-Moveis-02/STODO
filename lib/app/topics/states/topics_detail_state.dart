import 'package:stodo/core/models/book_model.dart';

abstract class TopicsDetailState {}

class TopicsDetailLoading extends TopicsDetailState {}

class TopicsDetailSuccess extends TopicsDetailState {
  final List<BookModel> books;
  TopicsDetailSuccess({required this.books});
}

class TopicsDetailError extends TopicsDetailState {
  final String message;
  TopicsDetailError({required this.message});
}