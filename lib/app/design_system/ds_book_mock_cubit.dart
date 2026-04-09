import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stodo/core/enums/book_status_enum.dart';
import 'package:stodo/core/models/book_model.dart';

class DsBookMockCubit extends Cubit<BookModel> {
  DsBookMockCubit(super.initialBook);

  void update(BookStatus status, int currentPage) {
    emit(
      BookModel(
        id: state.id,
        title: state.title,
        author: state.author,
        statusStr: status.toDbString(),
        currentPage: currentPage,
        totalPages: state.totalPages,
        topicId: state.topicId,
        updatedAt: DateTime.now().toIso8601String(),
        imagePath: state.imagePath,
      ),
    );
  }
}
