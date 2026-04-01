import 'package:flutter/material.dart';
import 'package:stodo/core/components/buttons/primary_button.dart';
import 'package:stodo/core/components/form/color_selector.dart';
import 'package:stodo/core/components/form/custom_text_field.dart';
import 'package:stodo/core/components/form/icon_selector.dart';
import 'package:stodo/core/models/topic_model.dart';
import 'package:stodo/core/themes/colors.dart';
import '../../../core/themes/spacing.dart';

class CreateTopicBottomSheet extends StatefulWidget {
  final Function(TopicModel) onTopicCreate;
  const CreateTopicBottomSheet({super.key, required this.onTopicCreate});

  @override
  State<CreateTopicBottomSheet> createState() => _CreateTopicBottomSheet();
}

class _CreateTopicBottomSheet extends State<CreateTopicBottomSheet> {
  final _nameController = TextEditingController();
  String? selectedColorHex = AppColors.colorToHex(AppColors.topicColor1);
  TopicIcon? selectedIcon = TopicIcon.math;

  bool isLoading = false;
  String? error;
  final _formKey = GlobalKey<FormState>();

  Future<void> _submit() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final topic = TopicModel(
        id: null,
        name: _nameController.text,
        iconId: selectedIcon?.toDbString() ?? TopicIcon.math.toDbString(),
        colorHex: selectedColorHex ?? AppColors.colorToHex(AppColors.topicColor1),
      );
      widget.onTopicCreate(topic);

      Navigator.pop(context);
    } catch (e) {
      setState(() {
        error = 'Erro ao salvar';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (error != null)
              Text(error!, style: TextStyle(color: Colors.red)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Criar Novo Tópico",
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
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s24),
            CustomTextField(
              label: 'Nome do Tópico',
              hint: 'Ex: Cálculo I, Anatomia, História...',
              autoFocus: true,
              maxLength: 30,
              controller: _nameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Campo obrigatório';
                }
                if (value.length > 30) {
                  return 'Máximo de 30 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.s24),
            IconSelector(
              label: 'Escolha um Ícone',
              selectedIcon: selectedIcon,
              onIconSelected: (icon) {
                setState(() {
                  selectedIcon = icon;
                });
              },
            ),
            const SizedBox(height: AppSpacing.s32),
            ColorSelector(
              label: 'Cor do Tópico',
              selectedColorHex: selectedColorHex,
              onColorSelected: (color) {
                setState(() {
                  selectedColorHex = color;
                });
              },
            ),
            const SizedBox(height: AppSpacing.s24),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: 'Criar Tópico',
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
            const SizedBox(height: AppSpacing.s24)
          ],
        ),
      ),
    );
  }
}