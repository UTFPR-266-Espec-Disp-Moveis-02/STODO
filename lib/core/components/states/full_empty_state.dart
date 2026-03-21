import 'package:flutter/material.dart';
import '../../themes/theme_exports.dart';
import '../assets/app_empty_state_image.dart';
import '../buttons/primary_button.dart';
import '../buttons/custom_outline_button.dart';

/// Uma visualização de tela cheia para representar o estado "vazio" (Empty State).
///
/// Este componente é ideal para preencher telas principais do aplicativo que ainda
/// não possuem dados cadastrados, como a Dashboard ou a Home.
///
/// Ele exibe nativamente a imagem de ilustração vazia ([AppEmptyStateImage]),
/// título, subtítulo e duas ações (Botão Primário e Botão Outline).
class FullEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final String primaryButtonText;
  final VoidCallback onPrimaryPressed;
  final String outlineButtonText;
  final VoidCallback onOutlinePressed;

  const FullEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.primaryButtonText,
    required this.onPrimaryPressed,
    required this.outlineButtonText,
    required this.onOutlinePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AppEmptyStateImage(height: 200),
          const SizedBox(height: AppSpacing.s32),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.light,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.gray200,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.s32),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: primaryButtonText,
              onPressed: onPrimaryPressed,
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          SizedBox(
            width: double.infinity,
            child: CustomOutlineButton(
              text: outlineButtonText,
              onPressed: onOutlinePressed,
            ),
          ),
        ],
      ),
    );
  }
}
