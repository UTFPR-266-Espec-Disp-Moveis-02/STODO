import 'package:flutter/material.dart';
import 'package:stodo/core/themes/theme_exports.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final String? hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomDropdown({
    super.key,
    required this.label,
    this.hint,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.light,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.light),
          decoration: InputDecoration(
            hintText: hint ?? 'Selecione $label',
            prefixIcon: prefixIcon,
            hintStyle: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.gray300),
          ),
          icon:
              suffixIcon ??
              const Icon(Icons.keyboard_arrow_down, color: AppColors.gray300),
        ),
      ],
    );
  }
}
