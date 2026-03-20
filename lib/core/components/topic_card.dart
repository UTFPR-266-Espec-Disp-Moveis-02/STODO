import 'package:stodo/core/themes/theme_exports.dart';
import 'package:flutter/material.dart';

class TopicCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final int resourcesCount;
  final double progress; // 0.0 to 1.0
  final VoidCallback? onTap;

  const TopicCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.resourcesCount,
    required this.progress,
    this.onTap,
  });

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
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.s12),
                  ),
                  child: Icon(icon, color: color, size: 24),
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
