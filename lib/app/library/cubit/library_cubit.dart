import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:stodo/core/enums/book_status_enum.dart';
import '../repository/library_repository.dart';
import '../states/library_states.dart';

class LibraryCubit extends Cubit<LibraryStates> {
  final LibraryRepository repository;

  LibraryCubit(this.repository) : super(LibraryInitial());

  String _search = '';
  String? _status;
  Timer? _debounce;

  Future<void> init() async {
    await fetchBooks();
  }

  void changeStatus(BookStatus? status) {
    _status = status?.name;
    fetchBooks();
  }

  void onSearchChanged(String value) {
    _search = value;

    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 300), () {
      fetchBooks();
    });
  }

  Future<void> fetchBooks() async {
    try {
      emit(LibraryLoading());

      final books = await repository.getBooksByStatus(
        query: _search,
        status: _status,
      );

      emit(LibrarySuccess(books));
    } catch (e) {
      emit(LibraryError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
