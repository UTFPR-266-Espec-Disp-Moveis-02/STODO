import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stodo/app/library/cubit/library_cubit.dart';
import 'package:stodo/app/library/repository/library_repository.dart';
import 'package:stodo/app/library/states/library_states.dart';
import 'package:stodo/app/library/widgets/book_progress_modal.dart';
import 'package:stodo/core/enums/book_status_enum.dart';
import 'package:stodo/core/themes/spacing.dart';

import '../../../core/components/cards/book_list_card.dart';
import '../../../core/components/form/custom_text_field.dart';
import '../../../core/components/states/skeletons/book_list_card_skeleton.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<BookStatus?> _statuses = [
    null,
    BookStatus.reading,
    BookStatus.read,
    BookStatus.rereading,
    BookStatus.wantToRead,
  ];

  Future<void> _navigateToCreateUpdateBook(
    BuildContext context, [
    int? id,
  ]) async {
    final cubit = context.read<LibraryCubit>();

    final result = await Navigator.pushNamed(
      context,
      '/create-update-book',
      arguments: id != null ? {'id': id} : null,
    );

    if (result == true) {
      cubit.fetchBooks();
    }
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LibraryCubit(LibraryRepository())..fetchBooks(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: const Text(
                "Biblioteca",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add, size: AppSpacing.s24),
                  onPressed: () => _navigateToCreateUpdateBook(context),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(color: Colors.white10, height: 1),
              ),
            ),
            body: BlocBuilder<LibraryCubit, LibraryStates>(
              builder: (context, state) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(AppSpacing.s16),
                      child: CustomTextField(
                        hint: 'Pesquisar na biblioteca',
                        prefixIcon: const Icon(Icons.search),
                        borderRadius: 30,
                        onChanged: context.read<LibraryCubit>().onSearchChanged,
                      ),
                    ),

                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      onTap: (value) {
                        context.read<LibraryCubit>().changeStatus(
                          _statuses[_tabController.index],
                        );
                      },
                      tabs: const [
                        Tab(text: 'Todos'),
                        Tab(text: 'Lendo'),
                        Tab(text: 'Lido'),
                        Tab(text: 'Relendo'),
                        Tab(text: 'Quero Ler'),
                      ],
                    ),

                    Expanded(
                      child: BlocBuilder<LibraryCubit, LibraryStates>(
                        builder: (context, state) {
                          if (state is LibraryLoading) {
                            return ListView.builder(
                              itemCount: 4,
                              padding: EdgeInsets.all(AppSpacing.s16),

                              itemBuilder: (context, index) {
                                return BookListCardSkeleton();
                              },
                            );
                          }

                          if (state is LibraryError) {
                            return Center(child: Text(state.message));
                          }

                          if (state is LibrarySuccess) {
                            if (state.books.isEmpty) {
                              return const Center(
                                child: Text('Nenhum livro encontrado'),
                              );
                            }

                            return ListView.builder(
                              itemCount: state.books.length,
                              padding: EdgeInsets.all(AppSpacing.s16),
                              itemBuilder: (context, index) {
                                final book = state.books[index];

                                return BookListCard(
                                  title: book.title,
                                  imagePath: book.imagePath,
                                  author: book.author,
                                  status: book.status,
                                  currentPage: book.currentPage,
                                  totalPages: book.totalPages,
                                  onTap: () => BookProgressModal.show(
                                    context,
                                    book,
                                    onSave: (newStatus, newPage) {
                                      context.read<LibraryCubit>().updateBookProgress(
                                        book.id!,
                                        newStatus,
                                        newPage,
                                      );
                                    },
                                  ),
                                  onEdit: () => _navigateToCreateUpdateBook(
                                    context,
                                    book.id,
                                  ),
                                  onRemove: () {
                                    context.read<LibraryCubit>().deleteBook(book.id!);
                                  },
                                );
                              },
                            );
                          }

                          return const SizedBox();
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
