import 'package:stodo/core/themes/theme_exports.dart';
import 'dart:io';
import 'package:flutter/material.dart';

enum BookStatus {
  reading('Lendo'),
  read('Lido'),
  rereading('Relendo'),
  wantToRead('Quero Ler');

  final String label;
  const BookStatus(this.label);

  String toDbString() => name;

  static BookStatus fromDbString(String name) {
    return BookStatus.values.firstWhere(
      (e) => e.name == name,
      orElse: () => BookStatus.wantToRead,
    );
  }
}

class BookListCard extends StatelessWidget {
  final String? imagePath;
  final String title;
  final String author;
  final BookStatus status;

  /// Pode ser a data lida ("Maio, 2023"), o capítulo atual ("Capítulo 12") ou nulo
  final String? extraInfo;

  /// Progresso de 0.0 a 1.0 (Usado apenas se status for Lendo)
  final double? progress;

  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const BookListCard({
    super.key,
    this.imagePath,
    required this.title,
    required this.author,
    required this.status,
    this.extraInfo,
    this.progress,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final bool isReading = status == BookStatus.reading;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryMedium,
        borderRadius: BorderRadius.circular(AppSpacing.s16),
        border: Border.all(color: AppColors.primaryDarkAccent, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Indicador lateral azul se estiver "Lendo"
          if (isReading)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 4,
              child: Container(color: AppColors.primary),
            ),

          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Capa
                    Container(
                      width: 56,
                      height: 76,
                      decoration: BoxDecoration(
                        color: AppColors.primaryMedium,
                        borderRadius: BorderRadius.circular(AppSpacing.s8),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _buildImage(),
                    ),
                    const SizedBox(width: AppSpacing.s16),

                    // Detalhes do Livro
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.s8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.light,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.s2),
                            Text(
                              author,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.gray200),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.s8),
                            _buildStatusRow(context),
                          ],
                        ),
                      ),
                    ),

                    // Popup Menu (3 pontinhos)
                    PopupMenuButton<int>(
                      icon: const Icon(
                        Icons.more_vert,
                        color: AppColors.gray200,
                      ),
                      onSelected: (value) {
                        if (value == 0 && onRemove != null) {
                          onRemove!();
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 0,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete_outline,
                                color: AppColors.topicColor2,
                                size: 20,
                              ),
                              const SizedBox(width: AppSpacing.s8),
                              Text(
                                'Remover',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.topicColor2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(BuildContext context) {
    if (status == BookStatus.reading) {
      final prog = progress ?? 0.0;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                status.label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(prog * 100).toInt()}%',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.light,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s4),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.s4),
            child: LinearProgressIndicator(
              value: prog,
              minHeight: 6,
              backgroundColor: AppColors.primaryDarkAccent,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
        ],
      );
    }

    // Cores das badges
    Color badgeBgColor;
    Color badgeTextColor;

    switch (status) {
      case BookStatus.read:
        badgeBgColor = AppColors.topicColor3.withValues(alpha: 0.15);
        badgeTextColor = AppColors.topicColor3;
        break;
      case BookStatus.rereading:
        badgeBgColor = AppColors.topicColor1.withValues(alpha: 0.15);
        badgeTextColor = AppColors.topicColor1;
        break;
      case BookStatus.wantToRead:
      default:
        badgeBgColor = AppColors.gray400.withValues(alpha: 0.2);
        badgeTextColor = AppColors.gray200;
        break;
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s8,
            vertical: AppSpacing.s4,
          ),
          decoration: BoxDecoration(
            color: badgeBgColor,
            borderRadius: BorderRadius.circular(AppSpacing.s12),
          ),
          child: Text(
            status.label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: badgeTextColor,
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
        ),
        if (extraInfo != null && extraInfo!.isNotEmpty) ...[
          const SizedBox(width: AppSpacing.s8),
          Expanded(
            child: Text(
              extraInfo!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.gray300),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImage() {
    if (imagePath != null && imagePath!.isNotEmpty) {
      return Image.file(
        File(imagePath!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.primaryDarkAccent,
      child: const Center(
        child: Icon(Icons.book, size: 24, color: AppColors.gray300),
      ),
    );
  }
}
