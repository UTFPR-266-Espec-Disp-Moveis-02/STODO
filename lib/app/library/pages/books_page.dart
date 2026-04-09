import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stodo/app/library/cubit/books_cubit.dart';
import 'package:stodo/app/library/pages/create_update_book_page.dart';
import 'package:stodo/app/library/repository/books_repository.dart';
import 'package:stodo/app/library/states/books_states.dart';
import 'package:stodo/core/components/cards/book_list_card.dart';
import 'package:stodo/core/components/form/custom_text_field.dart';
import 'package:stodo/core/components/layout/animated_grid_view.dart';
import 'package:stodo/core/components/states/home_empty_state_card.dart';
import 'package:stodo/core/components/states/skeletons/skeleton.dart';
import 'package:stodo/core/models/book_model.dart';
import '../../../core/themes/theme_exports.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BooksCubit(BooksRepository())..loadBooks(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.primaryDark,
            appBar: AppBar(
              centerTitle: false,
              title: Text(
                "Biblioteca",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    size: AppSpacing.s24
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreateUpdateBookPage(),
                      ),
                    );
                  }
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(color: Colors.white10, height: 1),
              ),
            ),
            body: BlocBuilder<BooksCubit, BooksState>(
              builder: (context, state) {
                if (state is BooksLoadingState) {
                  return booksLoadingView();
                }

                if (state is BooksErrorState) {
                  return Center(child: Text(state.message));
                }

                if (state is BooksSuccessState) {
                  if (state.books.isEmpty) {
                    return HomeEmptyStateCard(
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
                    );
                    
                  } else {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.s16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              hint: 'Pesquisar na biblioteca',
                              prefixIcon: Icon(Icons.search),
                              onChanged: (value) {
                                context.read<BooksCubit>().onSearchChanged(value);
                              },
                            ),
                            const SizedBox(height: AppSpacing.s16),
                            bookSection(state.books),
                          ],
                        ),
                      ),
                    );
                  }
                }

                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }

  Widget bookSection(List<BookModel> bookProgress) {
    return Column(
      children: [
        bookProgress.isEmpty
          ? Text('Empty')
          : Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s12),
            child: AnimatedGridView(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0,
              children: bookProgress.map((book) {
                return BookListCard(
                  title: book.title,
                  author: book.author,
                  status: book.status,
                  extraInfo: null,
                  onTap: () {},
                  onRemove: () {},
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget booksLoadingView() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Skeleton(
              width: 60,
              height: 60,
              borderRadius: AppSpacing.s4,
              shape: BoxShape.rectangle,
            ),
            const SizedBox(width: AppSpacing.s16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Skeleton(height: 20, width: double.infinity),
                  SizedBox(height: AppSpacing.s8),
                  Skeleton(height: 14, width: 150),
                  SizedBox(height: AppSpacing.s8),
                  Skeleton(height: 12, width: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}