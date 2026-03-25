import 'package:flutter/material.dart';
import 'package:stodo/core/themes/theme_exports.dart';
import 'skeleton.dart';

class BookCardSkeleton extends StatelessWidget {
  const BookCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: 160,
              decoration: BoxDecoration(
                color: AppColors.primaryMedium,
                borderRadius: BorderRadius.circular(AppSpacing.s16),
                border: Border.all(
                  color: AppColors.primaryDarkAccent.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Skeleton(
                      width: 40,
                      height: 40,
                      borderRadius: AppSpacing.s12,
                    ),
                  ),

                  Positioned(
                    bottom: AppSpacing.s12,
                    left: AppSpacing.s12,
                    right: AppSpacing.s12,
                    child: const Skeleton(
                      height: 6,
                      borderRadius: AppSpacing.s4,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.s8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Skeleton(height: 16, width: 120, borderRadius: AppSpacing.s4),
                SizedBox(height: AppSpacing.s4),
                Skeleton(height: 12, width: 70, borderRadius: AppSpacing.s4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
