import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stodo/app/library/repository/library_repository.dart';
import 'package:stodo/app/topics/repository/topics_repository.dart';
import 'package:stodo/core/enums/book_status_enum.dart';
import 'package:stodo/core/models/topic_model.dart';

import '../../../core/models/book_model.dart';
import '../../../core/models/topic_progress_model.dart';
import '../repository/dashboard_repository.dart';
import '../states/dashboard_states.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _repository;
  final TopicsRepository _topicsRepository;

  DashboardCubit(this._repository, this._topicsRepository) : super(DashboardInitialState());

  Future<void> loadDashboard() async {
    emit(DashboardLoadingState());

    try {
      final results = await Future.wait([
        _repository.getRecentBooks(),
        _topicsRepository.getTopicsProgress(),
      ]);

      final recentBooks = results[0] as List<BookModel>;
      final topicProgress = results[1] as List<TopicProgressModel>;

      emit(
        DashboardSuccessState(
          recentBooks: recentBooks,
          topicProgress: topicProgress,
        ),
      );
    } catch (e) {
      emit(DashboardErrorState(message: 'Erro ao carregar dados'));
    }
  }

  Future<void> addTopic(TopicModel topic) async {
    try {
      await _topicsRepository.createTopic(topic);
      await loadDashboard();
    } catch (e) {
      emit(DashboardErrorState(message: 'Erro ao salvar tópico'));
    }
  }

  Future<void> updateBookProgress(
    int id,
    BookStatus status,
    int currentPage,
  ) async {
    try {
      await LibraryRepository().updateBookProgress(id, status, currentPage);
      await loadDashboard();
    } catch (e) {
      emit(DashboardErrorState(message: 'Erro ao atualizar progresso'));
    }
  }
}
