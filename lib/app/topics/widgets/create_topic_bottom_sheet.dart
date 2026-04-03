import 'package:flutter/material.dart';
import 'package:stodo/core/components/bottom_sheet/app_bottom_sheet.dart';
import 'package:stodo/core/components/buttons/primary_button.dart';
import 'package:stodo/core/components/form/color_selector.dart';
import 'package:stodo/core/components/form/custom_text_field.dart';
import 'package:stodo/core/components/form/icon_selector.dart';
import 'package:stodo/core/models/topic_model.dart';
import 'package:stodo/core/themes/colors.dart';
import 'package:stodo/core/utils/validators.dart';
import '../../../core/themes/spacing.dart';

class CreateTopicBottomSheet extends StatefulWidget {
  final Function(TopicModel) onTopicCreate;

  const CreateTopicBottomSheet({super.key, required this.onTopicCreate});

  static Future<void> show(
    BuildContext context, {
    required Function(TopicModel) onTopicCreate,
  }) {
    return AppBottomSheet.show(
      context,
      title: 'Criar Novo Tópico',
      builder: (_) => CreateTopicBottomSheet(onTopicCreate: onTopicCreate),
    );
  }

  @override
  State<CreateTopicBottomSheet> createState() => _CreateTopicBottomSheetState();
}

class _CreateTopicBottomSheetState extends State<CreateTopicBottomSheet> {
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
        colorHex:
            selectedColorHex ?? AppColors.colorToHex(AppColors.topicColor1),
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
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (error != null) ...[
            Text(error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: AppSpacing.s16),
          ],
          CustomTextField(
            label: 'Nome do Tópico',
            hint: 'Ex: Cálculo I, Anatomia, História...',
            autoFocus: true,
            maxLength: 30,
            controller: _nameController,
            validator: AppValidators.compose([
              AppValidators.required(),
              AppValidators.maxLength(30),
            ]),
          ),
          const SizedBox(height: AppSpacing.s24),
          IconSelector(
            label: 'Escolha um Ícone',
            selectedIcon: selectedIcon,
            onIconSelected: (icon) => setState(() => selectedIcon = icon),
          ),
          const SizedBox(height: AppSpacing.s32),
          ColorSelector(
            label: 'Cor do Tópico',
            selectedColorHex: selectedColorHex,
            onColorSelected: (color) =>
                setState(() => selectedColorHex = color),
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
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
