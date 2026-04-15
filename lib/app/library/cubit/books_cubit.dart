import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stodo/app/library/repository/books_repository.dart';
import 'package:stodo/app/library/states/books_states.dart';
import 'package:stodo/app/topics/repository/topics_repository.dart';
import 'package:stodo/core/enums/book_status_enum.dart';
import 'package:stodo/core/models/book_model.dart';
import 'package:stodo/core/models/topic_model.dart';

class BooksCubit extends Cubit<BooksState> {
  final BooksRepository _booksRepository;
  final TopicsRepository _topicsRepository;

  BooksCubit(this._booksRepository, this._topicsRepository, {int? id})
    : super(BooksState(status: Initial()));

  Future<void> loadInitialData({int? id}) async {
    emit(state.copyWith(status: Loading()));

    try {
      final statusList = BookStatus.values;
      final topicsList = await _topicsRepository.getTopicsDropdown();
      BookModel? book;

      if (id != null) {
        book = await _booksRepository.getBookById(id);
      }

      emit(
        state.copyWith(
          status: LoadSuccess(),
          statusOptions: statusList,
          topicOptions: topicsList,
          book: book,
          selectedStatus: book?.status ?? BookStatus.wantToRead,
          selectedTopic: book?.topic,
          imagePath: book?.imagePath,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: Error(message: 'Erro ao carregar dados')
      ));
    }
  }

  void updateStatus(BookStatus status) {
    emit(state.copyWith(selectedStatus: status));
  }

  void updateTopic(TopicModel? topic) {
    emit(state.copyWith(selectedTopic: topic));
  }

  void updateImage(String? path) {
    emit(state.copyWith(imagePath: path));
  }

  Future<void> save({
    required String title,
    required String author,
    required int numberOfPages
  }) async {
    try {
      final book = BookModel(
        id: state.book?.id,
        title: title,
        author: author,
        currentPage: state.book?.currentPage ?? 0,
        statusStr: state.selectedStatus?.name ?? '',
        totalPages: numberOfPages,
        topic: state.selectedTopic,
        updatedAt: DateTime.now().toIso8601String(),
        imagePath: state.imagePath,
      );

      await _booksRepository.createOrUpdateBook(book);
      emit(state.copyWith(status: SubmitSuccess(), book: book));
    } catch (e) {
      emit(state.copyWith(status: Error(message: 'Erro ao salvar')));
    }
  }
}