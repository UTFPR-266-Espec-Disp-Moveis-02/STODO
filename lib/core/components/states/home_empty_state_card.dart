import 'package:flutter/material.dart';
import 'package:stodo/core/themes/theme_exports.dart';
import '../form/dashed_border_painter.dart';

/// Um pequeno Card de estado vazio desenhado especificamente para a Dashboard.
///
/// Ele inclui uma borda tracejada envolta usando um [CustomPainter]
/// ([DashedBorderPainter]), fornecendo uma indicação visual amigável
/// e incentivando o usuário a interagir ("clique para adicionar").
///
/// Geralmente usado para carrosséis vazios (ex: Meus Livros, Meus Tópicos).
class HomeEmptyStateCard extends StatelessWidget {
  final IconData icon;
  final IconData? buttonIcon;
  final String title;
  final String? subtitle;
  final String buttonText;
  final VoidCallback onPressed;

  const HomeEmptyStateCard({
    super.key,
    required this.icon,
    this.buttonIcon,
    required this.title,
    this.subtitle,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(
        color: AppColors.gray400.withValues(alpha: 0.1),
        strokeWidth: 2,
        radius: AppSpacing.s16,
        dashPattern: const [6, 4],
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s24,
          vertical: AppSpacing.s32,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryMedium.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(AppSpacing.s16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryMedium,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.gray400, size: 32),
            ),
            const SizedBox(height: AppSpacing.s24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.light,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.s8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.gray300),
              ),
            ],
            const SizedBox(height: AppSpacing.s24),
            ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(
                buttonIcon ?? Icons.add,
                size: 20
              ),
              label: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
