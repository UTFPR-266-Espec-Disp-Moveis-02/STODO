import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stodo/app/library/states/book_progress_states.dart';
import 'package:stodo/core/enums/book_status_enum.dart';
import 'package:stodo/core/models/book_model.dart';

class BookProgressCubit extends Cubit<BookProgressState> {
  final BookModel book;

  BookProgressCubit(this.book)
      : super(
          BookProgressIdle(
            status: book.status,
            currentPage: book.currentPage,
          ),
        );

  void onStatusChanged(BookStatus newStatus) {
    final current = state;
    if (current is! BookProgressIdle) return;

    final newPage = newStatus.applyPageRule(current.currentPage, book.totalPages);
    emit(BookProgressIdle(status: newStatus, currentPage: newPage));
  }

  void onPageChanged(int page) {
    final current = state;
    if (current is! BookProgressIdle) return;

    emit(BookProgressIdle(status: current.status, currentPage: page));
  }

  Future<void> save() async {
    final current = state;
    if (current is! BookProgressIdle) return;

    final status = current.status;
    final page = current.currentPage;

    emit(BookProgressSaving());
    try {
      // TODO: chamar repository para atualizar o livro com status e page
      emit(BookProgressSaved(status: status, currentPage: page));
    } catch (e) {
      emit(BookProgressError('Erro ao salvar progresso'));
    }
  }
}
