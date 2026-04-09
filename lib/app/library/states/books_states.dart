import 'package:stodo/core/models/book_model.dart';

sealed class BooksState {}

class BooksInitialState extends BooksState {}

class BooksLoadingState extends BooksState {}

class BooksErrorState extends BooksState {
  final String message;

  BooksErrorState({required this.message});
}

class BooksSuccessState extends BooksState {
  final List<BookModel> books;

  BooksSuccessState({
    required this.books
  });
}