import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stodo/app/topics/cubit/topics_cubit.dart';
import 'package:stodo/app/topics/repository/topics_repository.dart';
import 'package:stodo/app/topics/states/topics_states.dart';
import 'package:stodo/app/topics/widgets/create_topic_bottom_sheet.dart';
import 'package:stodo/core/components/cards/topic_card.dart';
import 'package:stodo/core/components/form/custom_text_field.dart';
import 'package:stodo/core/components/form/icon_selector.dart';
import 'package:stodo/core/components/layout/animated_grid_view.dart';
import 'package:stodo/core/components/states/home_empty_state_card.dart';
import 'package:stodo/core/components/states/skeletons/skeleton.dart';
import 'package:stodo/core/components/states/skeletons/topic_card_skeleton.dart';
import 'package:stodo/core/models/topic_progress_model.dart';
import '../../../core/themes/theme_exports.dart';

class TopicsPage extends StatefulWidget {
  const TopicsPage({super.key});

  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TopicsCubit(TopicsRepository())..loadTopics(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.primaryDark,
            appBar: AppBar(
              centerTitle: false,
              title: Text(
                "Tópicos",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    size: AppSpacing.s24
                  ),
                  onPressed: () {
                    final topicCubit = context.read<TopicsCubit>();
                    CreateTopicBottomSheet.show(
                      context,
                      onTopicCreate: (topic) => topicCubit.addTopic(topic),
                    );
                  }
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(color: Colors.white10, height: 1),
              ),
            ),
            body: BlocBuilder<TopicsCubit, TopicsState>(
              builder: (context, state) {
                // MARK: Loading
                if (state is TopicsLoadingState) {
                  return topicsLoadingView();
                }
                // MARK: Error
                if (state is TopicsErrorState) {
                  return Center(child: Text(state.message));
                }
                // MARK: Success
                if (state is TopicsSuccessState) {
                  final isSearching = state.searchQuery.isNotEmpty;

                  final filteredList = isSearching
                    ? state.topicsProgress
                      .where((t) => t.name
                        .toLowerCase()
                        .contains(state.searchQuery.toLowerCase()))
                      .toList()
                    : state.topicsProgress;

                  final isEmpty = filteredList.isEmpty;

                  // MARK: Empty state sem busca
                  if (isEmpty && !isSearching) {
                    return HomeEmptyStateCard(
                      icon: Icons.menu_book,
                      title: 'Você ainda não criou tópicos',
                      subtitle:
                          'Organize seus estudos criando tópicos personalizados para seus livros e cursos.',
                      buttonText: 'Criar Tópico',
                      onPressed: () {
                        final topicCubit = context.read<TopicsCubit>();
                        CreateTopicBottomSheet.show(
                          context,
                          onTopicCreate: (topic) => topicCubit.addTopic(topic),
                        );
                      },
                    );
                  }

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            controller: _searchController,
                            hint: 'Pesquisar Tópicos',
                            prefixIcon: Icon(Icons.search),
                            onChanged: (value) {
                              context.read<TopicsCubit>().onSearchChanged(value);
                            },
                          ),
                          const SizedBox(height: AppSpacing.s16),
                          if (isEmpty && isSearching)
                            // MARK: Empty state para busca sem resultados
                            HomeEmptyStateCard(
                              icon: Icons.search_off,
                              title: 'Nenhum resultado encontrado',
                              subtitle: 'Nenhum resultado para "${state.searchQuery}"',
                              buttonText: 'Limpar busca',
                              buttonIcon: Icons.clear,
                              onPressed: () {
                                _searchController.clear();
                                context.read<TopicsCubit>().cleanSearchQuery();
                              },
                            )
                          else
                            // MARK: Lista de tópicos
                            topicProgressSection(filteredList),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }

  Widget topicProgressSection(List<TopicProgressModel> topicProgress) {
    return Column(
      children: [
        topicProgress.isEmpty
          ? Text('Empty')
          : Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s12),
            child: AnimatedGridView(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0,
              children: topicProgress.map((topic) {
                return TopicCard.fromHex(
                  icon: TopicIcon.fromDbString(topic.iconId).iconData,
                  colorStr: topic.colorHex,
                  title: topic.name,
                  totalRead: topic.totalRead,
                  resourcesCount: topic.totalPages,
                  onTap: () {},
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget topicsLoadingView() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Skeleton(height: 20, width: 120, borderRadius: AppSpacing.s4),
            const SizedBox(height: AppSpacing.s16),
            const SizedBox(height: AppSpacing.s24),
            const Skeleton(height: 20, width: 100, borderRadius: AppSpacing.s4),
            const SizedBox(height: AppSpacing.s16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: 4,
              itemBuilder: (context, index) => const TopicCardSkeleton(),
            ),
          ],
        ),
      ),
    );
  }
}