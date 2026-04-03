import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stodo/app/design_system/ds_book_mock_cubit.dart';
import 'package:stodo/app/library/widgets/book_progress_modal.dart';
import 'package:stodo/core/models/book_model.dart';
import 'package:stodo/core/models/book_status.dart';

import '../../core/components/assets/app_logo.dart';
import '../../core/components/assets/app_logo_horizontal.dart';
import '../../core/components/buttons/custom_outline_button.dart';
import '../../core/components/buttons/primary_button.dart';
import '../../core/components/cards/book_card.dart';
import '../../core/components/cards/book_list_card.dart';
import '../../core/components/cards/current_reading_card.dart';
import '../../core/components/cards/topic_card.dart';
import '../../core/components/form/color_selector.dart';
import '../../core/components/form/custom_dropdown.dart';
import '../../core/components/form/custom_text_field.dart';
import '../../core/components/form/icon_selector.dart';
import '../../core/components/form/image_upload_field.dart';
import '../../core/components/form/progress_updater.dart';
import '../../core/components/layout/animated_grid_view.dart';
import '../../core/components/states/full_empty_state.dart';
import '../../core/components/states/home_empty_state_card.dart';
import '../../core/components/states/skeletons/book_card_skeleton.dart';
import '../../core/components/states/skeletons/skeleton.dart';
import '../../core/components/states/skeletons/topic_card_skeleton.dart';
import '../../core/themes/theme_exports.dart';
import 'section_header.dart';

class DesignSystemPage extends StatefulWidget {
  const DesignSystemPage({super.key});

  @override
  State<DesignSystemPage> createState() => _DesignSystemPageState();
}

class _DesignSystemPageState extends State<DesignSystemPage> {
  String? _dropdownValue;
  String? _selectedColorHex;
  TopicIcon? _selectedIcon;
  bool _isLoading = false;

  static const _dsAuthors = {
    1: 'J.R.R. Tolkien',
    2: 'Frank Herbert',
    3: 'J.K. Rowling',
    4: 'George Orwell',
  };

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design System')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SectionHeader('Componentes Básicos'),
            ExpansionTile(
              title: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_note),
                  SizedBox(width: AppSpacing.s8),
                  Text(
                    'Formulários & Inputs',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              childrenPadding: const EdgeInsets.all(AppSpacing.s16),
              children: [
                const CustomTextField(
                  label: 'Text Field',
                  hint: 'Digite alguma coisa...',
                  prefixIcon: Icon(Icons.person),
                ),
                const SizedBox(height: AppSpacing.s16),
                const CustomTextField(
                  label: 'Password',
                  hint: 'Digite sua senha',
                  obscureText: true,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.visibility),
                ),
                const SizedBox(height: AppSpacing.s16),
                CustomDropdown<String>(
                  label: 'Dropdown de Opções',
                  value: _dropdownValue,
                  items: const [
                    DropdownMenuItem(value: '1', child: Text('Opção 1')),
                    DropdownMenuItem(value: '2', child: Text('Opção 2')),
                    DropdownMenuItem(value: '3', child: Text('Opção 3')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _dropdownValue = value;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.s16),
                ImageUploadField(
                  label: 'Capa do Livro',
                  onImageSelected: (path) {
                    debugPrint('Capa selecionada: $path');
                  },
                ),
              ],
            ),
            const Divider(height: 1),
            ExpansionTile(
              title: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.color_lens),
                  SizedBox(width: AppSpacing.s8),
                  Text(
                    'Seletores',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              childrenPadding: const EdgeInsets.all(AppSpacing.s16),
              children: [
                ColorSelector(
                  label: 'Cor do Tópico',
                  selectedColorHex: _selectedColorHex,
                  onColorSelected: (color) {
                    setState(() {
                      _selectedColorHex = color;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.s32),
                IconSelector(
                  label: 'Escolha um Ícone',
                  selectedIcon: _selectedIcon,
                  onIconSelected: (icon) {
                    setState(() {
                      _selectedIcon = icon;
                    });
                    },
                  ),
                ),
              ],
            ),
            const Divider(height: 1),
            ExpansionTile(
              title: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.smart_button),
                  SizedBox(width: AppSpacing.s8),
                  Text(
                    'Botões',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              childrenPadding: const EdgeInsets.all(AppSpacing.s16),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        text: 'Primary Button',
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s16),
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        text: 'With Icon',
                        icon: const Icon(Icons.check, size: 20),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s16),
                Row(
                  children: [
                    Expanded(
                      child: CustomOutlineButton(
                        text: 'Outline Button',
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s16),
                Row(
                  children: [
                    Expanded(
                      child: CustomOutlineButton(
                        text: 'With Icon',
                        icon: const Icon(Icons.add, size: 20),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Buttons Loading State',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      value: _isLoading,
                      onChanged: (val) => _toggleLoading(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s16),
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        text: 'Primary Loading',
                        isLoading: _isLoading,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s16),
                Row(
                  children: [
                    Expanded(
                      child: CustomOutlineButton(
                        text: 'Outline Loading',
                        isLoading: _isLoading,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 1),
            const SectionHeader('Tópicos'),
            ExpansionTile(
              title: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.folder),
                  SizedBox(width: AppSpacing.s8),
                  Text(
                    'Cards de Tópico',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              childrenPadding: const EdgeInsets.all(AppSpacing.s16),
              children: [
                AnimatedGridView(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0, // Garantindo o formato 1x1
                  children: [
                    TopicCard(
                      icon: TopicIcon.math.iconData,
                      color: AppColors.topicColor1, // Azul
                      title: 'Cálculo I',
                      totalRead: 5,
                      resourcesCount: 12,
                      onTap: () {}, // Teste de tap no Design System
                    ),
                    TopicCard(
                      icon: Icons.smartphone,
                      color: AppColors.topicColor7, // Roxo
                      title: 'Mobile Dev',
                      totalRead: 5,
                      resourcesCount: 8,
                      onTap: () {},
                    ),
                    TopicCard(
                      icon: TopicIcon.brain.iconData,
                      color: AppColors.topicColor3, // Verde
                      title: 'IA Aplicada',
                      totalRead: 4,
                      resourcesCount: 24,
                      onTap: () {},
                    ),
                    TopicCard(
                      icon: TopicIcon.book.iconData,
                      color: AppColors.topicColor4, // Laranja
                      title: 'Literatura',
                      totalRead: 26,
                      resourcesCount: 30,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 1),
            const SectionHeader('Livros'),
            ExpansionTile(
              title: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.library_books),
                  SizedBox(width: AppSpacing.s8),
                  Text(
                    'Cards de Livro',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              childrenPadding: const EdgeInsets.all(AppSpacing.s16),
              children: [
                CurrentReadingCard(
                  title: 'Project Hail Mary',
                  author: 'Andy Weir',
                  progress: 0.74,
                  onTap: () {},
                ),
                const SizedBox(height: AppSpacing.s16),
                SizedBox(
                  height:
                      280, // Altura do container para acomodar a lista horizontal
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: AppSpacing.s16),
                    itemBuilder: (context, index) {
                      return BookCard(
                        imagePath:
                            null, // Deixando nulo para forçar o fundo cinza fallback com o ícone
                        title: [
                          'Cálculo I',
                          'Química Orgânica',
                          'História de Roma',
                          'Física Quântica',
                        ][index],
                        progress: [0.65, 0.30, 0.88, 0.15][index],
                        onTap:
                            () {}, // Teste de tap (efeito ripple) no Design System
                      );
                    },
                  ),
                ),
              ],
            ),
            const Divider(height: 1),
            ExpansionTile(
              title: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.view_list),
                  SizedBox(width: AppSpacing.s8),
                  Text(
                    'Lista de Livros',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              childrenPadding: const EdgeInsets.all(AppSpacing.s16),
              children: [
                ProgressUpdater(
                  currentValue: 352,
                  maxValue: 476,
                  onChanged: (val) {
                    debugPrint('Novo progresso: $val');
                  },
                ),
                const SizedBox(height: AppSpacing.s16),
                ...[
                  BookModel(
                    id: 1,
                    title: 'O Senhor dos Anéis',
                    status: BookStatus.read.toDbString(),
                    currentPage: 1178,
                    totalPages: 1178,
                    topicId: 1,
                    updatedAt: '',
                  ),
                  BookModel(
                    id: 2,
                    title: 'Duna',
                    status: BookStatus.reading.toDbString(),
                    currentPage: 309,
                    totalPages: 476,
                    topicId: 1,
                    updatedAt: '',
                  ),
                  BookModel(
                    id: 3,
                    title: 'Harry Potter',
                    status: BookStatus.rereading.toDbString(),
                    currentPage: 0,
                    totalPages: 320,
                    topicId: 1,
                    updatedAt: '',
                  ),
                  BookModel(
                    id: 4,
                    title: '1984',
                    status: BookStatus.wantToRead.toDbString(),
                    currentPage: 0,
                    totalPages: 328,
                    topicId: 1,
                    updatedAt: '',
                  ),
                ].map((mockBook) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                    child: BlocProvider(
                      create: (_) => DsBookMockCubit(mockBook),
                      child: Builder(
                        builder: (context) =>
                            BlocBuilder<DsBookMockCubit, BookModel>(
                              builder: (context, book) {
                                final status = BookStatus.fromDbString(
                                  book.status,
                                );
                                final progress = book.totalPages > 0
                                    ? book.currentPage / book.totalPages
                                    : 0.0;
                                return BookListCard(
                                  title: book.title,
                                  author: _dsAuthors[book.id] ?? '',
                                  status: status,
                                  progress: status == BookStatus.reading
                                      ? progress
                                      : null,
                                  onTap: () => BookProgressModal.show(
                                    context,
                                    book,
                                    onSave: (newStatus, newPage) {
                                      context.read<DsBookMockCubit>().update(
                                        newStatus,
                                        newPage,
                                      );
                                    },
                                  ),
                                  onRemove: () {},
                                );
                              },
                            ),
                      ),
                    ),
                  );
                }),
              ],
            ),
            const Divider(height: 1),
            const SectionHeader('Branding & Assets'),
            ExpansionTile(
              title: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.image),
                  SizedBox(width: AppSpacing.s8),
                  Text(
                    'Logos / Assets',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              childrenPadding: const EdgeInsets.all(AppSpacing.s16),
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Logo Quadrada',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                const Center(child: AppLogo(width: 80, height: 80)),
                const SizedBox(height: AppSpacing.s32),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Logo Horizontal',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                const Center(child: AppLogoHorizontal(height: 60)),
              ],
            ),
            const Divider(height: 1),
            const SectionHeader('Estados & Feedback'),
            ExpansionTile(
              title: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.layers_clear),
                  SizedBox(width: AppSpacing.s8),
                  Text(
                    'Empty States',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              childrenPadding: const EdgeInsets.all(AppSpacing.s16),
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Full Empty State (Dash/Home)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                Container(
                  color: AppColors.primaryDark,
                  child: FullEmptyState(
                    title: 'Sua jornada de estudos\ncomeça aqui',
                    subtitle:
                        'Cadastre seu primeiro livro ou crie um tópico\npara organizar seus materiais.',
                    primaryButtonText: 'Cadastrar Livro',
                    onPrimaryPressed: () {},
                    outlineButtonText: 'Criar Tópico',
                    onOutlinePressed: () {},
                  ),
                ),
                const SizedBox(height: AppSpacing.s32),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Home Empty States (Cards)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                HomeEmptyStateCard(
                  icon: Icons.menu_book,
                  title: 'Nenhum livro sendo lido agora',
                  buttonText: 'Adicionar Livro',
                  onPressed: () {},
                ),
                const SizedBox(height: AppSpacing.s16),
                HomeEmptyStateCard(
                  icon: Icons.menu_book,
                  title: 'Você ainda não criou tópicos',
                  subtitle:
                      'Organize seus estudos criando tópicos personalizados para seus livros e cursos.',
                  buttonText: 'Criar Tópico',
                  onPressed: () {},
                ),
              ],
            ),
            const Divider(height: 1),
            ExpansionTile(
              title: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.hourglass_empty),
                  SizedBox(width: AppSpacing.s8),
                  Text(
                    'Loading & Skeletons',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              childrenPadding: const EdgeInsets.all(AppSpacing.s16),
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Esqueletos Básicos',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Skeleton(
                      width: 60,
                      height: 60,
                      shape: BoxShape.circle,
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
                const SizedBox(height: AppSpacing.s32),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Topic Card Skeleton',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 280,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: AppSpacing.s16),
                    itemBuilder: (context, index) {
                      return BookCardSkeleton();
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                AnimatedGridView(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                  children: const [TopicCardSkeleton(), TopicCardSkeleton()],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s40),
          ],
        ),
      ),
    );
  }
}
