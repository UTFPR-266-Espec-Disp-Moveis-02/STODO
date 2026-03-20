import 'package:flutter/material.dart';

import '../../core/components/color_selector.dart';
import '../../core/components/custom_dropdown.dart';
import '../../core/components/custom_outline_button.dart';
import '../../core/components/custom_text_field.dart';
import '../../core/components/icon_selector.dart';
import '../../core/components/primary_button.dart';

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Inputs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 32),
            const Text(
              'Selectores',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ColorSelector(
              label: 'Cor do Tópico',
              selectedColorHex: _selectedColorHex,
              onColorSelected: (color) {
                setState(() {
                  _selectedColorHex = color;
                });
              },
            ),
            const SizedBox(height: 32),
            IconSelector(
              label: 'Escolha um Ícone',
              selectedIcon: _selectedIcon,
              onIconSelected: (icon) {
                setState(() {
                  _selectedIcon = icon;
                });
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Buttons',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Switch(value: _isLoading, onChanged: (val) => _toggleLoading()),
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
      ),
    );
  }
}
