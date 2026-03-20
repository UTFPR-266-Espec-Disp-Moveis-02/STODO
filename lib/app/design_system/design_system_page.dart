import 'package:flutter/material.dart';

import '../../core/components/animated_grid_view.dart';
import '../../core/components/color_selector.dart';
import '../../core/components/custom_dropdown.dart';
import '../../core/components/custom_outline_button.dart';
import '../../core/components/custom_text_field.dart';
import '../../core/components/icon_selector.dart';
import '../../core/components/primary_button.dart';

import '../../core/components/topic_card.dart';
import '../../core/themes/colors.dart';

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
              title: const Text(
                '🎨 Formulários & Inputs',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              initiallyExpanded: true,
              childrenPadding: const EdgeInsets.all(16),
              children: [
                const CustomTextField(
                  label: 'Text Field',
                  hint: 'Digite alguma coisa...',
                  prefixIcon: Icon(Icons.person),
                ),
                const SizedBox(height: 16),
                const CustomTextField(
                  label: 'Password',
                  hint: 'Digite sua senha',
                  obscureText: true,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.visibility),
                ),
                const SizedBox(height: 16),
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
              ],
            ),
            const Divider(height: 1),
            ExpansionTile(
              title: const Text(
                '🖱️ Seletores',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              childrenPadding: const EdgeInsets.all(16),
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
                const SizedBox(height: 32),
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
              title: const Text(
                '🕹️ Botões',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              childrenPadding: const EdgeInsets.all(16),
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
                const SizedBox(height: 16),
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
                const SizedBox(height: 32),
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
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
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
              title: const Text(
                '🗂️ Cards de Tópico',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              initiallyExpanded: true,
              childrenPadding: const EdgeInsets.all(16),
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
                    ),
                    TopicCard(
                      icon: Icons.smartphone,
                      color: AppColors.topicColor7, // Roxo
                      title: 'Mobile Dev',
                      resourcesCount: 8,
                      progress: 0.65,
                    ),
                    TopicCard(
                      icon: TopicIcon.brain.iconData,
                      color: AppColors.topicColor3, // Verde
                      title: 'IA Aplicada',
                      resourcesCount: 24,
                      progress: 0.15,
                    ),
                    TopicCard(
                      icon: TopicIcon.book.iconData,
                      color: AppColors.topicColor4, // Laranja
                      title: 'Literatura',
                      resourcesCount: 30,
                      progress: 0.85,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
