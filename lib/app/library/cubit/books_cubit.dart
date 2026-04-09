import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stodo/app/library/repository/books_repository.dart';
import 'package:stodo/app/library/states/books_states.dart';
import 'package:stodo/core/models/book_model.dart';

class BooksCubit extends Cubit<BooksState> {
  Timer? _debounce;
  final BooksRepository _repository;

  BooksCubit(this._repository) : super(BooksInitialState());

  Future<void> loadBooks({String? searchQuery}) async {
    emit(BooksLoadingState());

    try {
      final results = await Future.wait([
        _repository.getBooks(searchQuery: searchQuery)
      ]);

      final topics = results[0];

      emit(
        BooksSuccessState(
          books: topics
        ),
      );
    } catch (e) {
      emit(BooksErrorState(message: 'Erro ao carregar dados'));
    }
  }

  void onSearchChanged(String query) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      loadBooks(searchQuery: query);
    });
  }

  Future<void> createBook(BookModel book) async {
    emit(BooksLoadingState());

    try {
      await Future.wait([
        _repository.createBook(book)
      ]);
    } catch (e) {
      emit(BooksErrorState(message: 'Erro ao carregar dados'));
    }
  }

  Future<void> addBook(BookModel book) async {
    try {
      await _repository.createBook(book);
      await loadBooks();
    } catch (e) {
      emit(BooksErrorState(message: 'Erro ao salvar livro'));
    }
  }
}