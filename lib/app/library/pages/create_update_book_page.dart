import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stodo/app/library/cubit/books_cubit.dart';
import 'package:stodo/app/library/repository/books_repository.dart';
import 'package:stodo/app/library/states/books_states.dart';
import 'package:stodo/app/topics/repository/topics_repository.dart';
import 'package:stodo/core/components/buttons/primary_button.dart';
import 'package:stodo/core/components/form/custom_dropdown.dart';
import 'package:stodo/core/components/form/custom_text_field.dart';
import 'package:stodo/core/components/form/image_upload_field.dart';
import 'package:stodo/core/enums/book_status_enum.dart';
import 'package:stodo/core/models/topic_model.dart';

import '../../../core/themes/theme_exports.dart';

class CreateUpdateBookPage extends StatefulWidget {
  final int? id;

  const CreateUpdateBookPage({super.key, this.id});

  @override
  State<CreateUpdateBookPage> createState() => _CreateUpdateBookPageState();
}

class _CreateUpdateBookPageState extends State<CreateUpdateBookPage> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _numberOfPagesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // MARK: Build
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BooksCubit(
        BooksRepository(),
        TopicsRepository(),
        id: widget.id
      )..loadInitialData(id: widget.id),
      child: Builder(
        builder: (context) {
          return BlocListener<BooksCubit, BooksState>(
            listenWhen: (prev, curr) => prev.status != curr.status,
            listener: (context, state) {
              if (state.status is SubmitSuccess) {
                Navigator.pop(context);
              }

              if (state.status is Error) {
                final error = (state.status as Error).message;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error)),
                );
              }
            },
            child: BlocListener<BooksCubit, BooksState>(
              listenWhen: (prev, curr) => prev.book != curr.book,
              listener: (context, state) {
                _titleController.text = state.book?.title ?? '';
                _authorController.text = state.book?.author ?? '';
                _numberOfPagesController.text = state.book?.totalPages.toString() ?? '';
              },
              child: BlocBuilder<BooksCubit, BooksState>(
                builder: (context, state) {
                  if (state.status is Loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Scaffold(
                    backgroundColor: AppColors.primaryDark,
                    appBar: AppBar(
                      centerTitle: false,
                      title: Text(
                        widget.id == null ? "Novo Livro" : "Editar Livro",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)
                      ),
                      leading: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          size: AppSpacing.s24
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }
                      ),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(1),
                        child: Container(color: Colors.white10, height: 1),
                      ),
                    ),
                    body: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.s16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // MARK: Upload Imagem
                              ImageUploadField(
                                label: 'Capa do Livro',
                                initialImagePath: state.imagePath,
                                onImageSelected: (path) {
                                  context.read<BooksCubit>().updateImage(path);
                                },
                              ),
                              const SizedBox(height: AppSpacing.s16),
                              // MARK: Titulo
                              CustomTextField(
                                label: 'Título do Livro',
                                hint: 'Ex: O Senhor dos Anéis',
                                controller: _titleController,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Campo obrigatório';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: AppSpacing.s16),
                              // MARK: Autor
                              CustomTextField(
                                label: 'Autor',
                                hint: 'Ex: J.R.R. Tolkien',
                                controller: _authorController,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Campo obrigatório';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: AppSpacing.s16),
                              // MARK: Total de Páginas e Status
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CustomTextField(
                                      label: 'Total de Páginas',
                                      hint: '0',
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      controller: _numberOfPagesController,
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return 'Campo obrigatório';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    flex: 1,
                                    child: CustomDropdown<BookStatus>(
                                      label: 'Status',
                                      value: state.selectedStatus,
                                      items: state.statusOptions
                                        .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e.label),
                                        )
                                      ).toList(),
                                      onChanged: (value) {
                                        context.read<BooksCubit>().updateStatus(value!);
                                      },
                                    ),
                                  ),
                                ]
                              ),
                              const SizedBox(height: AppSpacing.s16),
                              // MARK: Categoria / Tópico
                              CustomDropdown<TopicModel>(
                                label: 'Categoria / Tópico',
                                value: state.selectedTopic,
                                hint: 'Selecione um tópico',
                                suffixIcon: const Icon(Icons.category, size: 20),
                                items: [
                                  DropdownMenuItem(
                                    value: null,
                                    child: Text("Sem Tópico"),
                                  ),
                                  ...state.topicOptions
                                    .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.name),
                                    )
                                  )
                                ],
                                onChanged: (value) {
                                  context.read<BooksCubit>().updateTopic(value!);
                                },
                              ),
                              const SizedBox(height: AppSpacing.s16),
                              Row(
                                children: [
                                  Expanded(
                                    child: PrimaryButton(
                                      text: widget.id == null ? "Cadastrar Livro" : "Editar Livro",
                                      icon: const Icon(Icons.add_box, size: 20),
                                      isLoading: state.status is Loading,
                                      onPressed: () {
                                        if (state.status is! Loading &&
                                            _formKey.currentState!.validate()) {
                                          context.read<BooksCubit>().save(
                                            title: _titleController.text,
                                            author: _authorController.text,
                                            numberOfPages: int.tryParse(_numberOfPagesController.text) ?? 0,
                                          );
                                        }
                                      }
                                    ),
                                  ),
                                ],
                              ),
                              //const SizedBox(height: AppSpacing.s24),
                              //const SizedBox(height: AppSpacing.s16),
                            ],
                          ),
                        )
                      ),
                    ),
                  );
                }
              )
            )
          );
        }
      )
    );
  }
}

/*
// Criar
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CreateUpdateBookPage(),
  ),
);

// Editar
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CreateUpdateBookPage(id: 1),
  ),
);
*/