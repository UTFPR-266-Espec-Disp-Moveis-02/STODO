import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stodo/app/library/cubit/book_progress_cubit.dart';
import 'package:stodo/app/library/repository/library_repository.dart';
import 'package:stodo/app/library/states/book_progress_states.dart';
import 'package:stodo/core/components/buttons/primary_button.dart';
import 'package:stodo/core/components/form/custom_dropdown.dart';
import 'package:stodo/core/components/form/progress_updater.dart';
import 'package:stodo/core/enums/book_status_enum.dart';
import 'package:stodo/core/models/book_model.dart';
import 'package:stodo/core/themes/colors.dart';
import 'package:stodo/core/themes/spacing.dart';

class BookDetailsPage extends StatelessWidget {
  final BookModel book;

  const BookDetailsPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookProgressCubit(book),
      child: BlocListener<BookProgressCubit, BookProgressState>(
        listener: (context, state) async {
          if (state is BookProgressSaved) {
            await LibraryRepository().updateBookProgress(
              book.id!,
              state.status,
              state.currentPage,
            );
            if (context.mounted) {
              Navigator.pop(context, true);
            }
          } else if (state is BookProgressError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.topicColor2,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.primaryDark,
          appBar: AppBar(
            centerTitle: false,
            title: Text(
              book.title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: Colors.white10, height: 1),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<BookProgressCubit, BookProgressState>(
                  buildWhen: (_, curr) => curr is BookProgressIdle,
                  builder: (context, state) {
                    final currentStatus =
                        state is BookProgressIdle ? state.status : book.status;
                    return CustomDropdown<BookStatus>(
                      label: 'Status da leitura',
                      value: currentStatus,
                      items: BookStatus.values.map((s) {
                        return DropdownMenuItem(
                          value: s,
                          child: Row(
                            children: [
                              Icon(s.icon, color: s.color, size: AppSpacing.s16),
                              const SizedBox(width: AppSpacing.s8),
                              Text(s.label),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (s) {
                        if (s != null) {
                          context.read<BookProgressCubit>().onStatusChanged(s);
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.s24),
                BlocBuilder<BookProgressCubit, BookProgressState>(
                  buildWhen: (_, curr) => curr is BookProgressIdle,
                  builder: (context, state) {
                    final currentPage = state is BookProgressIdle
                        ? state.currentPage
                        : book.currentPage;
                    return ProgressUpdater(
                      currentValue: currentPage,
                      maxValue: book.totalPages,
                      onChanged: (page) =>
                          context.read<BookProgressCubit>().onPageChanged(page),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.s24),
                BlocBuilder<BookProgressCubit, BookProgressState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: 'Salvar',
                        isLoading: state is BookProgressSaving,
                        onPressed: state is BookProgressSaving
                            ? null
                            : () => context.read<BookProgressCubit>().save(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
