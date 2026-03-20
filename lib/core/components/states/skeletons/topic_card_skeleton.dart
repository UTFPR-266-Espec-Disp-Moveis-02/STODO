import 'package:flutter/material.dart';
import 'package:stodo/core/themes/theme_exports.dart';
import 'skeleton.dart';

class TopicCardSkeleton extends StatelessWidget {
  const TopicCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.primaryMedium,
        borderRadius: BorderRadius.circular(AppSpacing.s20),
        border: Border.all(
          color: AppColors.primaryDarkAccent.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Skeleton(width: 48, height: 48, borderRadius: AppSpacing.s12),
          const Spacer(),
          const Skeleton(height: 16, width: 100, borderRadius: AppSpacing.s4),
          const SizedBox(height: AppSpacing.s8),
          const Skeleton(height: 12, width: 60, borderRadius: AppSpacing.s4),
          const SizedBox(height: AppSpacing.s16),
          Row(
            children: const [
              Expanded(child: Skeleton(height: 6, borderRadius: AppSpacing.s4)),
              SizedBox(width: AppSpacing.s8),
              Skeleton(height: 12, width: 30, borderRadius: AppSpacing.s4),
            ],
          ),
        ],
      ),
    );
  }
}
