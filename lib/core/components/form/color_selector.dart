import 'package:stodo/core/themes/theme_exports.dart';
import 'package:flutter/material.dart';

class ColorSelector extends StatefulWidget {
  final String label;
  final String? selectedColorHex;
  final ValueChanged<String> onColorSelected;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  const ColorSelector({
    super.key,
    required this.label,
    this.selectedColorHex,
    required this.onColorSelected,
    this.validator,
    this.autovalidateMode,
  });

  @override
  State<ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  final _fieldKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      key: _fieldKey,
      initialValue: widget.selectedColorHex,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      builder: (state) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
              widget.label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: state.hasError ? AppColors.topicColor2 : AppColors.gray200,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: AppColors.topicColors.map((color) {
                final colorHex = AppColors.colorToHex(color);
                final isSelected = colorHex == widget.selectedColorHex;

                return GestureDetector(
                  onTap: () {
                    widget.onColorSelected(colorHex);
                    state.didChange(colorHex);
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? color : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            if (state.hasError) ...[
              const SizedBox(height: AppSpacing.s8),
              Text(
                state.errorText!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.topicColor2),
              ),
            ],
          ],
          ),
        );
      },
    );
  }
}
