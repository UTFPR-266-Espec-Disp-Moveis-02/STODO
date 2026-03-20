import 'package:flutter/material.dart';
import 'package:stodo/core/themes/theme_exports.dart';

/// Botão principal (Primary Action) do sistema STODO.
///
/// Componente altamente reutilizável que aplica a cor primária global da marca
/// e possui suporte unificado para ícones e estado de progresso ([isLoading]).
/// Utilize-o para ações de confirmação e continuação vitais na jornada do sistema.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final Widget childWidget = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.black,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: AppSpacing.s8),
              ],
              Text(text),
            ],
          );

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: childWidget,
    );
  }
}
