import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stodo/app/library/cubit/books_cubit.dart';
import 'package:stodo/app/library/repository/books_repository.dart';
import 'package:stodo/core/components/buttons/primary_button.dart';
import 'package:stodo/core/components/form/custom_dropdown.dart';
import 'package:stodo/core/components/form/custom_text_field.dart';
import 'package:stodo/core/components/form/image_upload_field.dart';

import '../../../core/themes/theme_exports.dart';

class CreateUpdateBookPage extends StatefulWidget {
  final int? id;

  const CreateUpdateBookPage({super.key, this.id});

  @override
  State<CreateUpdateBookPage> createState() => _CreateUpdateBookPageState();
}

class _CreateUpdateBookPageState extends State<CreateUpdateBookPage> {
  String? _statusDropdownValue;
  String? _categoriaTopicoDropdownValue;
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _numberOfPagesController = TextEditingController();

  bool isLoading = false;
  String? error;
  final _formKey = GlobalKey<FormState>();

  Future<void> _submit() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      // final book = BookModel()
      // Logica com widget.id
      // widget.onBookCreate(book);
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        error = 'Erro ao salvar';
        isLoading = false;
      });
    }
  }

  Widget _booksFormPage() {
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
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageUploadField(
                label: 'Capa do Livro',
                onImageSelected: (path) {
                  debugPrint('Capa selecionada: $path');
                },
              ),
              const SizedBox(height: AppSpacing.s16),
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
                    child: CustomDropdown<String>(
                      label: 'Status',
                      value: _statusDropdownValue,
                      items: const [
                        DropdownMenuItem(value: '1', child: Text('Opção 1')),
                        DropdownMenuItem(value: '2', child: Text('Opção 2')),
                        DropdownMenuItem(value: '3', child: Text('Opção 3')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _statusDropdownValue = value;
                        });
                      },
                    ),
                  ),
                ]
              ),
              const SizedBox(height: AppSpacing.s16),
              CustomDropdown<String>(
                label: 'Categoria / Tópico',
                value: _categoriaTopicoDropdownValue,
                suffixIcon: const Icon(Icons.category, size: 20),
                items: const [
                  DropdownMenuItem(value: '1', child: Text('Opção 1')),
                  DropdownMenuItem(value: '2', child: Text('Opção 2')),
                  DropdownMenuItem(value: '3', child: Text('Opção 3')),
                ],
                onChanged: (value) {
                  setState(() {
                    _categoriaTopicoDropdownValue = value;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.s16),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      text: widget.id == null ? "Cadastrar Livro" : "Editar Livro",
                      icon: const Icon(Icons.add_box, size: 20),
                      isLoading: isLoading,
                      onPressed: () {
                        if (!isLoading && _formKey.currentState!.validate()) {
                          _submit();
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BooksCubit(BooksRepository()),
      child: _booksFormPage(),
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