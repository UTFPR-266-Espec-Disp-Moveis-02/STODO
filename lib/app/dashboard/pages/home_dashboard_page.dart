import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stodo/app/dashboard/cubit/dashboard_cubit.dart';
import 'package:stodo/app/dashboard/repository/dashboard_repository.dart';
import 'package:stodo/app/dashboard/states/dashboard_states.dart';
import 'package:stodo/app/library/pages/create_update_book_page.dart';
import 'package:stodo/app/topics/repository/topics_repository.dart';
import 'package:stodo/app/topics/widgets/create_topic_bottom_sheet.dart';
import 'package:stodo/core/models/book_model.dart';

import '../../../core/components/assets/app_logo_horizontal.dart';
import '../../../core/components/cards/book_card.dart';
import '../../../core/components/cards/topic_card.dart';
import '../../../core/components/form/icon_selector.dart';
import '../../../core/components/layout/animated_grid_view.dart';
import '../../../core/components/states/full_empty_state.dart';
import '../../../core/components/states/home_empty_state_card.dart';
import '../../../core/models/topic_progress_model.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/spacing.dart';
import '../widgets/dashboard_loading_view.dart';

class HomeDashboardPage extends StatefulWidget {
  final VoidCallback onNavigateToTopics;
  const HomeDashboardPage({super.key, required this.onNavigateToTopics});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
        DashboardCubit(
          DashboardRepository(),
          TopicsRepository()
        )..loadDashboard(),
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        appBar: AppBar(
          centerTitle: false,
          title: AppLogoHorizontal(height: 42, width: 145),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 17),
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {},
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.gray400, width: 1),
                      color: AppColors.gray400.withValues(alpha: 0.2),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_outline,
                        color: Colors.white60,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: Colors.white10, height: 1),
          ),
        ),
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoadingState) {
              return DashboardLoadingView();
            }

            if (state is DashboardErrorState) {
              return Center(child: Text(state.message));
            }

            if (state is DashboardSuccessState) {
              if (state.recentBooks.isEmpty && state.topicProgress.isEmpty) {
                return fullEmptyState(context);
              } else {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.s16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        recentBookSection(state.recentBooks),
                        const SizedBox(height: AppSpacing.s16),
                        topicProgressSection(state.topicProgress),
                      ],
                    ),
                  ),
                );
              }
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget fullEmptyState(BuildContext context) {
    return Container(
      color: AppColors.primaryDark,
      child: FullEmptyState(
        title: 'Sua jornada de estudos\ncomeça aqui',
        subtitle:
            'Cadastre seu primeiro livro ou crie um tópico\npara organizar seus materiais.',
        primaryButtonText: 'Cadastrar Livro',
        onPrimaryPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateUpdateBookPage(),
            ),
          );
        },
        outlineButtonText: 'Criar Tópico',
        onOutlinePressed: () {
          final dashboardCubit = context.read<DashboardCubit>();
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            builder: (BuildContext context) {
              return CreateTopicBottomSheet(
                onTopicCreate: (topic) {
                  dashboardCubit.addTopic(topic);
                },
              );
            }
          );
        },
      ),
    );
  }

  Widget topicProgressSection(List<TopicProgressModel> topicProgress) {
    return Column(
      children: [
        sectionTitle('Tópicos', widget.onNavigateToTopics, topicProgress.isEmpty),

        topicProgress.isEmpty
            ? HomeEmptyStateCard(
                icon: Icons.menu_book,
                title: 'Você ainda não criou tópicos',
                subtitle:
                    'Organize seus estudos criando tópicos personalizados para seus livros e cursos.',
                buttonText: 'Criar Tópico',
                onPressed: () {},
              )
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

  Widget recentBookSection(List<BookModel> recentBooks) {
    return Column(
      children: [
        sectionTitle('Lendo agora', () {}, recentBooks.isEmpty),
        recentBooks.isEmpty
            ? HomeEmptyStateCard(
                icon: Icons.menu_book,
                title: 'Nenhum livro sendo lido agora',
                buttonText: 'Adicionar Livro',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateUpdateBookPage(),
                    ),
                  );
                },
              )
            : Column(
                children: [
                  SizedBox(
                    height: 280,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: recentBooks.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: AppSpacing.s16),
                      itemBuilder: (context, index) {
                        return BookCard(
                          imagePath: recentBooks[index].imagePath,
                          title: recentBooks[index].title,
                          progress:
                              recentBooks[index].currentPage /
                              recentBooks[index].totalPages,
                          onTap: () {},
                        );
                      },
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  Widget sectionTitle(String label, Function()? onPressed, bool emptyState) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.light,
            ),
          ),
          if (!emptyState)
            TextButton(onPressed: onPressed, child: const Text('Ver Todos')),
        ],
      ),
    );
  }
}
