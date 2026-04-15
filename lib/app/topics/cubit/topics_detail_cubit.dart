import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stodo/app/library/repository/books_repository.dart';
import '../states/topics_detail_state.dart';

class TopicsDetailCubit extends Cubit<TopicsDetailState> {
  final BooksRepository _booksRepository;

  TopicsDetailCubit(this._booksRepository) : super(TopicsDetailLoading());

  Future<void> loadBooks(int topicId) async {
    emit(TopicsDetailLoading());
    try {
      final books = await _booksRepository.getBooksByTopicId(topicId: topicId);
      emit(TopicsDetailSuccess(books: books));
    } catch (e) {
      emit(TopicsDetailError(message: 'Erro ao carregar livros.'));
    }
  }

  Future<void> deleteBook(int bookId, int topicId) async {
    try {
      await _booksRepository.deleteBook(bookId);
      await loadBooks(topicId);
    } catch (e) {
      emit(TopicsDetailError(message: 'Erro ao deletar livro.'));
    }
  }
}