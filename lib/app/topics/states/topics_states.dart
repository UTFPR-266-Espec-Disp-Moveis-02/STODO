import 'package:stodo/core/models/topic_progress_model.dart';

sealed class TopicsState {}

class TopicsInitialState extends TopicsState {}

class TopicsLoadingState extends TopicsState {}

class TopicsErrorState extends TopicsState {
  final String message;

  TopicsErrorState({required this.message});
}

class TopicsSuccessState extends TopicsState {
  final List<TopicProgressModel> topicsProgress;
  final String searchQuery;

  TopicsSuccessState({
    required this.topicsProgress,
    this.searchQuery = ''
  });
}