import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stodo/core/helpers/colors_helper.dart';
import 'package:stodo/core/models/book_model.dart';
import 'package:stodo/core/models/topic_progress_model.dart';
import 'package:stodo/core/themes/colors.dart';
import 'package:stodo/core/themes/spacing.dart';

import '../../../core/components/cards/book_list_card.dart';
import '../../../core/components/form/icon_selector.dart';
import '../../library/pages/create_update_book_page.dart';
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
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateUpdateBookPage(id: bookId, topicId: topic.id),
      ),
    );

    if (result == true && context.mounted) {
      context.read<TopicsDetailCubit>().loadBooks(topic.id);
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
                expandedHeight: 160.0,
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
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 22,
                    ),
                    onPressed: () {},
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
                                if (!isLoading && books.isNotEmpty)
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
                await Navigator.pushNamed(
                  context,
                  '/book-details',
                  arguments: book.id,
                );
                if (!context.mounted) return;
                context.read<TopicsDetailCubit>().loadBooks(topic.id);
              },
              onEdit: () =>
                  _navigateToCreateUpdateBook(context, bookId: book.id),
              onRemove: () {},
            ),
          );
        }, childCount: booksList.length),
      ),
    );
  }
}
