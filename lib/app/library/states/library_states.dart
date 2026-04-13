import '../../../core/models/book_model.dart';

sealed class LibraryStates {}

class LibraryInitial extends LibraryStates {}

class LibraryLoading extends LibraryStates {}

class LibrarySuccess extends LibraryStates {
  final List<BookModel> books;

  LibrarySuccess(this.books);
}

class LibraryError extends LibraryStates {
  final String message;

  LibraryError(this.message);
}
