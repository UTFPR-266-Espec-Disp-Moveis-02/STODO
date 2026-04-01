import 'package:stodo/core/themes/theme_exports.dart';
import 'package:flutter/material.dart';

class ColorSelector extends StatelessWidget {
  final String label;
  final String? selectedColorHex;
  final ValueChanged<String> onColorSelected;

  const ColorSelector({
    super.key,
    required this.label,
    this.selectedColorHex,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppColors.gray200),
        ),
        const SizedBox(height: AppSpacing.s12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: AppColors.topicColors.map((color) {
            final colorHex = AppColors.colorToHex(color);
            final isSelected = colorHex == selectedColorHex;

            return GestureDetector(
              onTap: () => onColorSelected(colorHex),
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
