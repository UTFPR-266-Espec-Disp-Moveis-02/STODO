import 'package:stodo/core/themes/theme_exports.dart';
import 'package:flutter/material.dart';

import '../../core/components/animated_grid_view.dart';
import '../../core/components/book_card.dart';
import '../../core/components/book_list_card.dart';
import '../../core/components/color_selector.dart';
import '../../core/components/custom_dropdown.dart';
import '../../core/components/custom_outline_button.dart';
import '../../core/components/custom_text_field.dart';
import '../../core/components/icon_selector.dart';
import '../../core/components/image_upload_field.dart';
import '../../core/components/primary_button.dart';
import '../../core/components/progress_updater.dart';
import '../../core/components/current_reading_card.dart';
import '../../core/components/skeletons/skeleton.dart';
import '../../core/components/skeletons/topic_card_skeleton.dart';
import '../../core/components/app_logo.dart';

import '../../core/components/topic_card.dart';

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
                Align(
                  alignment: Alignment.centerLeft,
                  child: ColorSelector(
                    label: 'Cor do Tópico',
                    selectedColorHex: _selectedColorHex,
                    onColorSelected: (color) {
                      setState(() {
                        _selectedColorHex = color;
                      });
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.s32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconSelector(
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
                      resourcesCount: 12,
                      progress: 0.45,
                      onTap: () {}, // Teste de tap no Design System
                    ),
                    TopicCard(
                      icon: Icons.smartphone,
                      color: AppColors.topicColor7, // Roxo
                      title: 'Mobile Dev',
                      resourcesCount: 8,
                      progress: 0.65,
                      onTap: () {},
                    ),
                    TopicCard(
                      icon: TopicIcon.brain.iconData,
                      color: AppColors.topicColor3, // Verde
                      title: 'IA Aplicada',
                      resourcesCount: 24,
                      progress: 0.15,
                      onTap: () {},
                    ),
                    TopicCard(
                      icon: TopicIcon.book.iconData,
                      color: AppColors.topicColor4, // Laranja
                      title: 'Literatura',
                      resourcesCount: 30,
                      progress: 0.85,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 1),
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
                BookListCard(
                  title: 'O Senhor dos Anéis',
                  author: 'J.R.R. Tolkien',
                  status: BookStatus.read,
                  extraInfo: 'Maio, 2023',
                  onTap: () {},
                  onRemove: () {},
                ),
                const SizedBox(height: AppSpacing.s16),
                BookListCard(
                  title: 'Duna',
                  author: 'Frank Herbert',
                  status: BookStatus.reading,
                  progress: 0.65,
                  onTap: () {},
                  onRemove: () {},
                ),
                const SizedBox(height: AppSpacing.s16),
                BookListCard(
                  title: 'Harry Potter',
                  author: 'J.K. Rowling',
                  status: BookStatus.rereading,
                  extraInfo: 'Capítulo 12',
                  onTap: () {},
                  onRemove: () {},
                ),
                const SizedBox(height: AppSpacing.s16),
                BookListCard(
                  title: '1984',
                  author: 'George Orwell',
                  status: BookStatus.wantToRead,
                  onTap: () {},
                  onRemove: () {},
                ),
              ],
            ),
            const Divider(height: 1),
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
                const SizedBox(height: AppSpacing.s32),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Empty State',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                const Center(child: AppEmptyStateImage(height: 150)),
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
