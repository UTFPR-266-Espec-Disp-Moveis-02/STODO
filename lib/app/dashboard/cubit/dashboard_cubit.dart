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
          recentBooks:
              //  [
              //   BookModel(
              //     id: 1,
              //     title: 'João e o Pé de Feijão',
              //     status: 'lendo',
              //     currentPage: 20,
              //     totalPages: 200,
              //     topicId: 1,
              //     updatedAt: '',
              //   ),
              //   BookModel(
              //     id: 2,
              //     title: 'As Crônicas de Nárnia',
              //     status: 'lendo',
              //     currentPage: 38,
              //     totalPages: 200,
              //     topicId: 1,
              //     updatedAt: '',
              //   ),
              //   BookModel(
              //     id: 2,
              //     title: 'João e Maria',
              //     status: 'lendo',
              //     currentPage: 180,
              //     totalPages: 200,
              //     topicId: 1,
              //     updatedAt: '',
              //   ),
              // ],
              recentBooks,
          topicProgress: [
            TopicProgressModel(
              id: 1,
              name: 'Calculo',
              iconId: 'bookScroll',
              colorHex: '0xffFF5722',
              totalRead: 200,
              totalPages: 785,
            ),
            TopicProgressModel(
              id: 1,
              name: 'Matemática',
              iconId: 'math',
              colorHex: '0xFF106821',
              totalRead: 0,
              totalPages: 3800,
            ),
            TopicProgressModel(
              id: 1,
              name: 'História',
              iconId: 'brain',
              colorHex: '0xFF511CC2',
              totalRead: 465,
              totalPages: 1200,
            ),
          ], //topicProgress,
        ),
      );
    } catch (e) {
      emit(DashboardErrorState(message: 'Erro ao carregar dados'));
    }
  }
}
