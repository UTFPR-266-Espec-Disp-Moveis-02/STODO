import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stodo/app/topics/repository/topics_repository.dart';
import 'package:stodo/app/topics/states/topics_states.dart';
import 'package:stodo/core/models/topic_model.dart';

class TopicsCubit extends Cubit<TopicsState> {
  Timer? _debounce;
  final TopicsRepository _repository;

  TopicsCubit(this._repository) : super(TopicsInitialState());

  Future<void> loadTopics({String? searchQuery}) async {
    emit(TopicsLoadingState());

    try {
      final results = await Future.wait([
        _repository.getTopicsProgress(searchQuery: searchQuery)
      ]);

      final topics = results[0];

      emit(
        TopicsSuccessState(
          topicsProgress: topics
        ),
      );
    } catch (e) {
      emit(TopicsErrorState(message: 'Erro ao carregar dados'));
    }
  }

  void onSearchChanged(String query) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      loadTopics(searchQuery: query);
    });
  }

  Future<void> createTopic(TopicModel topic) async {
    emit(TopicsLoadingState());

    try {
      await Future.wait([
        _repository.createTopic(topic)
      ]);
    } catch (e) {
      emit(TopicsErrorState(message: 'Erro ao carregar dados'));
    }
  }

  Future<void> addTopic(TopicModel topic) async {
    try {
      await _repository.createTopic(topic);
      await loadTopics();
    } catch (e) {
      emit(TopicsErrorState(message: 'Erro ao salvar tópico'));
    }
  }
}