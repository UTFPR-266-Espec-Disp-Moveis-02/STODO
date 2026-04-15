import 'package:stodo/core/themes/theme_exports.dart';
import 'package:flutter/material.dart';

/// Card para representação de um Tópico de estudo (ex: "Programação", "Direito").
///
/// Mostra visualmente um Tópico contendo ícone estilizado com a cor escolhida pelo
/// usuário, o nome do Tópico, quantidade de recursos e a barra de progresso.
///
/// Utilizado predominantemente nas telas de Listagem de Tópicos e Dashboard.
class TopicCard extends StatelessWidget {
  final IconData icon;
  final String colorStr;
  final Color color;
  final String title;
  final int totalRead;
  final int resourcesCount;
  final double progress; // 0.0 to 1.0
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TopicCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.totalRead,
    required this.resourcesCount,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : colorStr = '',
       progress = resourcesCount > 0 ? totalRead / resourcesCount : 0.0;

  factory TopicCard.fromHex({
    Key? key,
    required IconData icon,
    required String colorStr,
    required String title,
    required int totalRead,
    required int resourcesCount,
    VoidCallback? onTap,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    return TopicCard(
      key: key,
      icon: icon,
      color: Color(
        int.parse(colorStr.replaceFirst('#', '0xFF')),
      ),
      title: title,
      totalRead: totalRead,
      resourcesCount: resourcesCount,
      onTap: onTap,
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.s20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.2)],
        ),
      ),
      padding: const EdgeInsets.all(1.5), // A espessura da nossa "borda"
      child: Material(
        color: AppColors.primaryMedium,
        borderRadius: BorderRadius.circular(AppSpacing.s20 - 1.5),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize:
                  MainAxisSize.min, // Se adapta ao conteúdo em flex/grids
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppSpacing.s12),
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    if (onEdit != null || onDelete != null) ...[
                      const Spacer(),
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        iconSize: 18,
                        color: AppColors.primaryMedium,
                        onSelected: (value) {
                          if (value == 'edit') onEdit?.call();
                          if (value == 'delete') onDelete?.call();
                        },
                        itemBuilder: (_) => [
                          if (onEdit != null)
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 16),
                                  SizedBox(width: 8),
                                  Text('Editar'),
                                ],
                              ),
                            ),
                          if (onDelete != null)
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, size: 16, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Deletar', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
                const Spacer(), // Ocupa espaço restante (ótimo para GridView)
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.light,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  '$resourcesCount resources',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.gray300),
                ),
                const SizedBox(height: AppSpacing.s16),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSpacing.s4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: AppColors.primaryDarkAccent,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s8),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.gray200,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
