import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stodo/core/themes/theme_exports.dart';

/// Um campo de texto customizado padronizado para o aplicativo STODO.
///
/// Este componente empacota um [TextFormField] padrão do Flutter, adicionando
/// estilos globais, suporte a label superior e comportamento automático de
/// fechamento do teclado ao tocar fora do campo ([onTapOutside]).
///
/// Ideal para formulários, configurações e áreas de input ao longo do app.
class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autoFocus;
  final bool obscureText;
  final int? maxLength;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlign;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final double borderRadius;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.focusNode,
    this.autoFocus = false,
    this.obscureText = false,
    this.maxLength,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.onFieldSubmitted,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: AppColors.gray200),
          ),
          const SizedBox(height: AppSpacing.s8),
        ],
        TextFormField(
          controller: controller,
          autofocus: autoFocus,
          obscureText: obscureText,
          maxLength: maxLength,
          validator: validator,
          keyboardType: keyboardType,
          textAlign: textAlign,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          inputFormatters: inputFormatters,
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            hintStyle: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.gray300),
          ),
        ),
      ],
    );
  }
}
