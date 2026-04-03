import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stodo/app/library/cubit/book_progress_cubit.dart';
import 'package:stodo/app/library/states/book_progress_states.dart';
import 'package:stodo/core/components/buttons/primary_button.dart';
import 'package:stodo/core/components/form/custom_dropdown.dart';
import 'package:stodo/core/components/form/progress_updater.dart';
import 'package:stodo/core/models/book_model.dart';
import 'package:stodo/core/models/book_status.dart';
import 'package:stodo/core/themes/colors.dart';
import 'package:stodo/core/themes/spacing.dart';

class BookProgressModal {
  BookProgressModal._();

  static Future<void> show(
    BuildContext context,
    BookModel book, {
    void Function(BookStatus status, int currentPage)? onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.primaryDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.s24),
        ),
      ),
      builder: (_) => BlocProvider(
        create: (_) => BookProgressCubit(book),
        child: _BookProgressContent(book: book, onSave: onSave),
      ),
    );
  }
}

class _BookProgressContent extends StatelessWidget {
  final BookModel book;
  final void Function(BookStatus status, int currentPage)? onSave;

  const _BookProgressContent({required this.book, this.onSave});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookProgressCubit, BookProgressState>(
      listener: (context, state) {
        if (state is BookProgressSaved) {
          onSave?.call(state.status, state.currentPage);
          Navigator.pop(context);
        } else if (state is BookProgressError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.topicColor2,
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s20,
          vertical: AppSpacing.s12,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray400,
                  borderRadius: BorderRadius.circular(AppSpacing.s4),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Progresso de Leitura',
                    style: TextStyle(
                      color: AppColors.light,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: AppSpacing.s24,
                      color: AppColors.gray200,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s24),

              // Status dropdown
              BlocBuilder<BookProgressCubit, BookProgressState>(
                buildWhen: (prev, curr) => curr is BookProgressIdle,
                builder: (context, state) {
                  final currentStatus = state is BookProgressIdle
                      ? state.status
                      : BookStatus.fromDbString(book.status);

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

              // Progress updater
              BlocBuilder<BookProgressCubit, BookProgressState>(
                buildWhen: (prev, curr) => curr is BookProgressIdle,
                builder: (context, state) {
                  final currentPage = state is BookProgressIdle
                      ? state.currentPage
                      : book.currentPage;

                  return ProgressUpdater(
                    currentValue: currentPage,
                    maxValue: book.totalPages,
                    onChanged: (page) {
                      context.read<BookProgressCubit>().onPageChanged(page);
                    },
                  );
                },
              ),
              const SizedBox(height: AppSpacing.s24),

              // OK button
              BlocBuilder<BookProgressCubit, BookProgressState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          text: 'OK',
                          isLoading: state is BookProgressSaving,
                          onPressed: state is BookProgressSaving
                              ? null
                              : () => context.read<BookProgressCubit>().save(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
