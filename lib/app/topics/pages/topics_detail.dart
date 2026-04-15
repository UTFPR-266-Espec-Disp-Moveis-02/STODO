import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stodo/app/dashboard/cubit/dashboard_cubit.dart';
import 'package:stodo/app/topics/cubit/topics_cubit.dart';
import 'package:stodo/app/topics/repository/topics_repository.dart';
import 'package:stodo/app/topics/widgets/create_topic_bottom_sheet.dart';
import 'package:stodo/core/helpers/colors_helper.dart';
import 'package:stodo/core/models/book_model.dart';
import 'package:stodo/core/models/topic_model.dart';
import 'package:stodo/core/models/topic_progress_model.dart';
import 'package:stodo/core/themes/colors.dart';
import 'package:stodo/core/themes/spacing.dart';

import '../../../core/components/cards/book_list_card.dart';
import '../../../core/components/form/icon_selector.dart';
import '../cubit/topics_detail_cubit.dart';
import '../states/topics_detail_state.dart';

class TopicsDetailPage extends StatelessWidget {
  final TopicProgressModel topic;

  const TopicsDetailPage({super.key, required this.topic});

  double _calculateOverallProgress(List<BookModel> books) {
    if (books.isEmpty) return 0.0;
    int totalRead = 0;
    int totalPages = 0;
    for (var book in books) {
      totalRead += book.currentPage;
      totalPages += book.totalPages;
    }
    return totalPages == 0 ? 0.0 : totalRead / totalPages;
  }

  Future<void> _navigateToCreateUpdateBook(
    BuildContext context, {
    int? bookId,
  }) async {
    if (!context.mounted) return;
    final detailCubit = context.read<TopicsDetailCubit>();
    final dashboardCubit = context.read<DashboardCubit>();
    final topicsCubit = context.read<TopicsCubit>();

    final result = await Navigator.pushNamed(
      context,
      '/create-update-book',
      arguments: {'id': bookId, 'topicId': topic.id},
    );

    if (result == true) {
      detailCubit.loadBooks(topic.id);
      dashboardCubit.loadDashboard();
      topicsCubit.loadTopics();
    }
  }

  @override
  Widget build(BuildContext context) {
    final topicColor = topic.colorHex.toColor();

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: BlocBuilder<TopicsDetailCubit, TopicsDetailState>(
        builder: (context, state) {
          List<BookModel> books = [];
          bool isLoading = state is TopicsDetailLoading;

          if (state is TopicsDetailSuccess) {
            books = state.books;
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                pinned: true,
                backgroundColor: AppColors.primaryDark,
                scrolledUnderElevation: 0,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white70,
                      size: 20,
                    ),
                    onPressed: () {
                      CreateTopicBottomSheet.show(
                        context,
                        existingTopic: TopicModel(
                          id: topic.id,
                          name: topic.name,
                          iconId: topic.iconId,
                          colorHex: topic.colorHex,
                        ),
                        onTopicCreate: (updated) async {
                          await TopicsRepository().updateTopic(updated);
                          if (context.mounted) {
                            context.read<DashboardCubit>().loadDashboard();
                            context.read<TopicsCubit>().loadTopics();
                          }
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 22,
                    ),
                    onPressed: () async {
                      final dashboardCubit = context.read<DashboardCubit>();
                      final topicsCubit = context.read<TopicsCubit>();
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Deletar Tópico'),
                          content: Text(
                            'Deseja deletar "${topic.name}"? Os livros associados não serão removidos.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                'Deletar',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await TopicsRepository().deleteTopic(topic.id);
                        dashboardCubit.loadDashboard();
                        topicsCubit.loadTopics();
                        if (context.mounted) Navigator.pop(context);
                      }
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.s24,
                        kToolbarHeight + AppSpacing.s16,
                        AppSpacing.s24,
                        0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: topicColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: topicColor.withValues(alpha: 0.4),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                TopicIcon.fromDbString(topic.iconId).iconData,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.s16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  topic.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${books.length} Livros Vinculados • Criado em Outubro',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                if (!isLoading && books.isNotEmpty) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Progresso Geral',
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.6,
                                          ),
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '${(_calculateOverallProgress(books) * 100).toInt()}%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: _calculateOverallProgress(books),
                                      minHeight: 6,
                                      backgroundColor: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.s24,
                    0,
                    AppSpacing.s24,
                    AppSpacing.s2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Livros Vinculados',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () => _navigateToCreateUpdateBook(context),
                        child: const Text(
                          '+ Adicionar',
                          style: TextStyle(
                            color: AppColors.blueAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (state is TopicsDetailLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state is TopicsDetailError)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                )
              else if (books.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Nenhum livro vinculado.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                )
              else
                _buildBookSliverSection(books, topicColor),

              const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBookSliverSection(List<BookModel> booksList, Color topicColor) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s24,
        vertical: AppSpacing.s8,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final book = booksList[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: BookListCard(
              title: book.title,
              author: book.author,
              status: book.status,
              imagePath: book.imagePath,
              currentPage: book.currentPage,
              totalPages: book.totalPages,
              onTap: () async {
                final detailCubit = context.read<TopicsDetailCubit>();
                final dashboardCubit = context.read<DashboardCubit>();
                final topicsCubit = context.read<TopicsCubit>();
                final result = await Navigator.pushNamed(
                  context,
                  '/book-details',
                  arguments: book,
                );
                if (result == true) {
                  detailCubit.loadBooks(topic.id);
                  dashboardCubit.loadDashboard();
                  topicsCubit.loadTopics();
                }
              },
              onEdit: () =>
                  _navigateToCreateUpdateBook(context, bookId: book.id),
              onRemove: () async {
                final cubit = context.read<TopicsDetailCubit>();
                final dashboardCubit = context.read<DashboardCubit>();
                final topicsCubit = context.read<TopicsCubit>();
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Remover Livro'),
                    content: Text(
                      'Deseja remover "${book.title}" deste tópico?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          'Remover',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  cubit.deleteBook(book.id!, topic.id);
                  dashboardCubit.loadDashboard();
                  topicsCubit.loadTopics();
                }
              },
            ),
          );
        }, childCount: booksList.length),
      ),
    );
  }
}
