import '../../../core/models/book_model.dart';
import '../../../core/models/topic_progress_model.dart';

sealed class DashboardState {}

class DashboardInitialState extends DashboardState {}

class DashboardLoadingState extends DashboardState {}

class DashboardErrorState extends DashboardState {
  final String message;

  DashboardErrorState({required this.message});
}

class DashboardSuccessState extends DashboardState {
  final List<BookModel> recentBooks;
  final List<TopicProgressModel> topicProgress;

  DashboardSuccessState({
    required this.recentBooks,
    required this.topicProgress,
  });
}
