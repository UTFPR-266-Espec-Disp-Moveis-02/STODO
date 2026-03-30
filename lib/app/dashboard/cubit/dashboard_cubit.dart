import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/book_model.dart';
import '../../../core/models/topic_progress_model.dart';
import '../repository/dashboard_repository.dart';
import '../states/dashboard_states.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _repository;

  DashboardCubit(this._repository) : super(DashboardInitialState());

  Future<void> loadDashboard() async {
    emit(DashboardLoadingState());

    try {
      final results = await Future.wait([
        _repository.getRecentBooks(),
        _repository.getTopicsProgress(),
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
}
