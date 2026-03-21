import 'package:flutter/material.dart';
import 'package:stodo/core/themes/theme_exports.dart';

/// Um campo de texto customizado padronizado para o aplicativo STODO.
///
/// Este componente empacota um [TextFormField] padrão do Flutter, adicionando
/// estilos globais, suporte a label superior e comportamento automático de
/// fechamento do teclado ao tocar fora do campo ([onTapOutside]).
///
/// Ideal para formulários, configurações e áreas de input ao longo do app.
class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.onFieldSubmitted,
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
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          keyboardType: keyboardType,
          textAlign: textAlign,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
            if (onFieldSubmitted != null && controller != null) {
              onFieldSubmitted!(controller!.text);
            }
          },
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.light),
          decoration: InputDecoration(
            hintText: hint ?? 'Ex: $label',
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            hintStyle: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.gray300),
          ),
        ),
      ],
    );
  }
}
