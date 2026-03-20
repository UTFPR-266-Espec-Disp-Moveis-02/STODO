import 'package:flutter/material.dart';
import '../themes/colors.dart';

class TopicCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final int resourcesCount;
  final double progress; // 0.0 to 1.0

  const TopicCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.resourcesCount,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryMedium,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryDarkAccent, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Se adapta ao conteúdo em flex/grids
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
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
          const SizedBox(height: 4),
          Text(
            '$resourcesCount resources',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.gray300),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: AppColors.primaryDarkAccent,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
              const SizedBox(width: 8),
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
    );
  }
}
