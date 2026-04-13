import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stodo/app/library/repository/library_repository.dart';
import 'package:stodo/core/models/book_status.dart';

import '../../../core/components/cards/book_list_card.dart';
import '../../../core/components/form/custom_text_field.dart';
import '../cubit/library_cubit.dart';
import '../states/library_states.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<String?> _statuses = [
    null,
    'Lendo',
    'Lido',
    'Relendo',
    'Quero Ler',
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Biblioteca",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocProvider(
        create: (context) => LibraryCubit(LibraryRepository())..fetchBooks(),
        child: Builder(
          builder: (context) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
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
                        return const Center(child: CircularProgressIndicator());
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
                          itemBuilder: (context, index) {
                            final book = state.books[index];

                            return BookListCard(
                              title: book.title,
                              imagePath: book.imagePath,
                              author: book.author,
                              status: BookStatus.fromDbString(book.status),
                              progress: book.totalPages / book.currentPage,
                              onTap: () {},
                              onRemove: () {},
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
      ),
    );
  }
}
