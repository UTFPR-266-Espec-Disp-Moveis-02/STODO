import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stodo/core/models/book_model.dart';
import 'package:stodo/core/models/book_status.dart';

class DsBookMockCubit extends Cubit<BookModel> {
  DsBookMockCubit(super.initialBook);

  void update(BookStatus status, int currentPage) {
    emit(
      BookModel(
        id: state.id,
        title: state.title,
        status: status.toDbString(),
        currentPage: currentPage,
        totalPages: state.totalPages,
        topicId: state.topicId,
        updatedAt: DateTime.now().toIso8601String(),
        imagePath: state.imagePath,
        author: state.author,
      ),
    );
  }
}
